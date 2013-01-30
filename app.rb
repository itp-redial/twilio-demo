require 'sinatra'
require 'twilio-ruby'
require_relative 'sms.rb'

#set up sinatra
configure do
  set :send_sms_password, "interact2013"
  conf=YAML.load_file('twilio_conf.yml')
  set :twilio_account_sid, conf['account_sid']
  set :twilio_auth_token, conf['auth_token']
  set :twilio_from_number, conf['from_number']

  mysql_conf=YAML.load_file('mysql_conf.yml')
  DataMapper.setup(:default, {
      :adapter => 'mysql',
      :host => mysql_conf['host'],
      :username => mysql_conf['username'] ,
      :password => mysql_conf['password'],
      :database => mysql_conf['database']})
  # Automatically create the tables if they don't exist
  DataMapper.auto_upgrade!
  # Finish setup
  DataMapper.finalize
end

helpers do

  #pick 5 unique numbers 1-59, and 1 number 1-35
  def get_lotto_numbers
    nums = []
    5.times do
      num = rand(58)+1
      while nums.include? num
        num = rand(58)+1
      end
      nums << num
    end
    nums << rand(34)+1
    "Your lotto numbers:\n#{nums[0]} #{nums[1]} #{nums[2]} #{nums[3]} #{nums[4]} - Powerball #{nums[5]}\nGood Luck!"
  end

  #get a random cat fact
  def get_cat_facts
    facts = []
    facts << "Cats use their tails to balance and have nearly 30 bones in them!"
    facts << "In ancient Egypt killing a cat was a crime punishable by death."
    facts << "Did you know that the first cat show was held in 1871 at the Crystal Palace in London?  Mee-wow!"
    facts << "Did you know that there are about 100 distinct breeds of domestic cat?  Plenty of furry love!"
    facts << "Cats bury their feces to cover their trails from predators."
    facts[rand(facts.size)]
  end
end

get "/" do
  #get the 20 most recent SMS messages
  @sms_messages = SMS.all(:limit => 20, :order => [:created_at.desc])
  erb :main
end

#receive SMS and store in database
post "/receive_sms/?" do
    puts "post receive_sms"
    puts params.inspect
  body = params["Body"]
  #send lotto numbers?
  reply_message = get_lotto_numbers if body.downcase.include? ("lott")
  #send cat facts?
  reply_message = get_cat_facts if body.downcase.include?("cat") && body.downcase.include?("facts")
  if reply_message  # return message
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms reply_message
    end
    twiml.text
  else #stick message in database
    sms = SMS.create(:body => params['Body'], :from => params['From'], :to => params['To'], :created_at => Time.now)
  end
end


get "/send_sms/?" do
   erb :send_sms_form
end

post "/send_sms/?" do
  puts "post send_sms"
  @message="password is incorrect.  SMS failed." if settings.send_sms_password != params["password"]
  @message = "missing phone number.  SMS failed." if params["phone_number"].nil? || params["phone_number"].empty?
  @message = "missing SMS message.  SMS failed." if params["message"].nil? || params["message"].empty?
  #if there's no message then the password matches and we have all of the required info
  if @message.nil?
    puts "sending sms"
    client = Twilio::REST::Client.new(settings.twilio_account_sid, settings.twilio_auth_token)
    account = client.account
    @sms_reply = account.sms.messages.create({:from => settings.twilio_from_number, :to => params["phone_number"], :body => params["message"]})
    puts "got back this: #{@sms_reply.inspect}"
  end

  if @message #render the original form again, with error message
    erb :send_sms_form
  else #render the message that sms was sent
    erb :sms_sent
  end
end