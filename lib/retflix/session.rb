require 'rubygems'
require 'oauth'
require 'nokogiri'

module Retflix
  RESOURCE_BASE = 'http://api.netflix.com'
  
  class Session
    
    def initialize(consumer_key, consumer_secret, access_token = nil, access_token_secret = nil)
      consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site=>RESOURCE_BASE})
      @oauth_session = OAuth::AccessToken.new(consumer, access_token, access_token_secret)
    end
    
    def method_missing(method_name, *args, &block)
      return RestResourceTranslator.new(@oauth_session, nil, method_name)
    end
  end
  
end