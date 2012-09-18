
require 'bundler'
Bundler.require
require 'yaml'
require 'sinatra/reloader'

configure do
  use Rack::Session::Cookie, :key => 'kankan',
                             :domain => nil,
                             :path => '/',
                             :expire_after => nil, # In seconds
                             :secret => ''
                             
  use Rack::Flash, :sweep => true
  set :root, File.expand_path(".")
  set :public_folder, settings.root + "/public"
  set :views, settings.root + "/app/views/"
  Mongoid.logger = Logger.new($stdout)
  Moped.logger = Logger.new($stdout)
end


Mongoid.load!('./config/database.yml', :development)

WeiboOAuth2::Config.api_key = '2114819521'
WeiboOAuth2::Config.api_secret = '0a78c15afc77c027c45631beac88c9e8'
WeiboOAuth2::Config.redirect_uri = 'http://test.kennx.net:4567/callback'

Dir.glob("./app/helpers/*.rb") {|file| require file}
Dir.glob("./app/models/*.rb") {|file| require file}
Dir.glob("./app/controllers/*.rb") {|file| require file}


