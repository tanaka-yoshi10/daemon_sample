require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'haml'

JSON_FILE = "./setting.json"
PID_FILE  = "./daemon.pid"
SCRIPT    = "sh ./test_daemon"

get '/' do
  @status = File.exist?(PID_FILE) ? "running" : "stopped"
  haml :index
end

get '/setting.json' do
  content_type 'application/csv'
  send_file(JSON_FILE)
end

get '/start' do
  puts `#{SCRIPT} start`
  redirect '/'
end

get '/stop' do
  puts `#{SCRIPT} stop`
  redirect '/'
end

put '/upload' do
  if params[:file]
    save_path = JSON_FILE
    File.open(save_path, 'wb') do |f|
      f.write params[:file][:tempfile].read
    end
  end
  haml :index
end
__END__
@@index
%html
  %body
    = @status
    %a(href="start" title="start")
      start
    %a(href="stop" title="stop")
      stop
    %form{:action => '/upload', :method => 'POST', :enctype => 'multipart/form-data'}
      %input{:type => 'file',   :name => 'file'}
      %input{:type => 'submit', :value => 'upload'}
      %input{:type => 'hidden', :name => '_method', :value => 'put'}
