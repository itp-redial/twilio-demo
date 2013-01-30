require File.dirname(__FILE__) + '/app.rb'

#GET RID OF THIS IF YOU AREN'T DEPLOYING ON THE ITP OR REDIAL SERVER
before do
  s = request.path_info
  s[/^\/~(\w)+\/sinatra\/[^\/|?]+/i] = ""
  request.path_info = s
end

run Sinatra::Application
