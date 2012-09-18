require "./config/boot"
use Rack::Session::Cookie, :key => 'kankan_io',
                             :domain => nil,
                             :path => '/',
                             :expire_after => nil, 
                             :secret => ''
                             
use Rack::Flash, :sweep => true

run Sinatra::Application