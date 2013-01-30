require 'rubygems'
require 'twilio-ruby'
require 'yaml'

@from_number= '+1917xxxxxx' #replace with phone number provided by twilio
@to_number= '1646xxxxxxx'  #replace with actual phone number
@body = "This is the text body" #replace with your text message

conf=YAML.load_file('twilio_conf_internal.yml')
@account_sid = conf['account_sid']
@auth_token = conf['auth_token']

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new(@account_sid, @auth_token)

@account = @client.account
@message = @account.sms.messages.create({:from => @from_number, :to => @to_number, :body => @body})
puts @message
