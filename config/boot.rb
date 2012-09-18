
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
WEIBO_CONFIG = YAML.load_file("./config/weibo.yml")
WeiboOAuth2::Config.api_key = WEIBO_CONFIG['api_key']
WeiboOAuth2::Config.api_secret = WEIBO_CONFIG['api_secret']
WeiboOAuth2::Config.redirect_uri = WEIBO_CONFIG['redirect_uri']

Dir.glob("./app/helpers/*.rb") {|file| require file}
Dir.glob("./app/models/*.rb") {|file| require file}
Dir.glob("./app/controllers/*.rb") {|file| require file}


