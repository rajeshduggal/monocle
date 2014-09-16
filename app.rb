require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/sequel'
require 'sinatra/static_cache'
require 'active_support/json'
require 'stylus/sprockets'
require 'sprockets/commonjs'
require 'rack/session/dalli'
require 'rack/csrf'
require 'rediscloud'

require 'brisk/parsers'
require 'app/models'
require 'app/helpers'
require 'app/extensions'
require 'app/routes'

module Brisk
  class App < Sinatra::Application

    register Sinatra::ConfigFile

    config_file './config.yml'

    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/monocle_#{environment}"
      }
    end

    configure do
      disable :method_override
      disable :static

      set :protection, except: :session_hijacking

      set :erb, escape_html: true

      set :sessions,
          :httponly     => true,
          :secure       => false,
          :expire_after => 5.years,
          :secret       => ENV['SESSION_SECRET'],
          :assets_host  => ENV['ASSETS_HOST'],
          :stream_subscribe_url => ENV['STREAM_SUBSCRIBE_URL']
    end


    configure do
      Mail.defaults do
        unless ENV['SMTP_ADDRESS']
            delivery_method :file
        else
            delivery_method :smtp, {
              :address              => ENV['SMTP_ADDRESS'],
              :port                 => ENV['SMTP_PORT'],
              :domain               => ENV['SMTP_DOMAIN'],
              :user_name            => ENV['SMTP_USER_NAME'],
              :password             => ENV['SMTP_PASSWORD'],
              :authentication       => ENV['SMTP_AUTHENTICATION'],
              :enable_starttls_auto => ENV['SMTP_ENABLE_STARTTLS_AUTO'] }
        end
      end
    end

    use Rack::Deflater
    use Rack::CSRF

    use Brisk::Routes::Static
    use Brisk::Routes::Users
    use Brisk::Routes::Posts
    use Brisk::Routes::Comments
    use Brisk::Routes::Client
  end
end

# To easily access models in the console
include Brisk::Models
