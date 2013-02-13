This Sinatra app is a simple demo of how to send and receive SMS with Twilio from a web app.

The app does 4 things:
- You can send an SMS to a remote number at /send_sms
- It will receive SMS sent to a Twilio phone number.
- If you SMS "lotto" then the app will return random lottery numbers.
- If you SMS "cat facts" then the app will return trivia about cats.
- Any other SMS will get stored in a MySQL database with Datamapper, and displayed on the home page.

The home page will show SMS that's been sent to your twilio number.  You should change the phone number in views/main.erb.  
Be sure to set up your twilio account.
- Go to https://www.twilio.com/user/account/phone-numbers/incoming and click on your phone number.
- Change the SMS Request URL to "http://YOURSERVER.COM/YOUR_SINATRA_APP_LOCATION/receive_sms"
- For example, on the Redial server it may look like this:

```
http://asterisk.itp-redial.com/~ck123/sinatra/twilio-demo/receive_sms
```

"/send_sms" will allow you to send an SMS to a remote number.  The password is in app.rb, and you should probably change it.

Here's how to get this running on ITP's server, or the Redial Asterisk server:
- (replace NETID with your NYU Net ID)
- change directories to the sinatra directory

```
cd sinatra/
``` 
- get this project from github

```
git clone https://github.com/itp-redial/twilio-demo.git
``` 
- change directories to the newly created twilio-demo folder

```
cd twilio-demo
```  
- add your MySQL credentials to mysql_conf.yml
- your username and database are your net ID.
- your password is in your home folder in a file called sqlpwd

```
cat ~/sqlpwd
nano mysql_conf.yml
```
- add your twilio credentials to twilio_conf.yml
- Your account SID and Auth Token are at the top of the page at https://www.twilio.com/user/account
- Your phone number is at https://www.twilio.com/user/account/phone-numbers/incoming

```
nano twilio_conf.yml
```  
- link the sinatra app to your public html folder

```
ln -s /home/NET-ID/sinatra/twilio-demo/ /home/NET-ID/public_html/sinatra/twilio-demo
```
- create a file called .htacces and add the following information, changing the NET-ID in PassengetAppRoot to your net id.

```
nano .htaccess
```
- add this info below...

```
PassengerEnabled on
RackBaseURI /sinatra
PassengerAppRoot /home/NET-ID/sinatra/twilio-demo
RackEnv development
```
- rename the Gemfile so that Passenger will ignore it.

```
mv Gemfile ignore_Gemfile
```

THAT'S IT!  Hopefully this will give a boost to create your own SMS enabled applications.  
If all you need to do is send and SMS from Ruby, then look at simple_sms.rb, included in this Git repo.

