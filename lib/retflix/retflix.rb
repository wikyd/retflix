require 'rubygems'
require 'oauth'
require 'nokogiri'

module Retflix
  VERSION = '0.1.0'
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
  
  class RetflixError < StandardError
    attr_reader :code
    attr_reader :response
    def initialize(code, response)
      @code   = code
      @response = response
    end
  end
  
  private
  
  class RestResourceTranslator

    def initialize(oauth_session, parent = nil, path_component = nil)
      @parent = parent
      @oauth_session = oauth_session
      @path_component = "#{path_component}" if path_component
    end

    def id(id)
      return RestResourceTranslator.new(@oauth_session, self, id)
    end

    def method_missing(method_name, *args, &block)
      return RestResourceTranslator.new(@oauth_session, self, method_name)
    end

    def get(query_params = {})
        resource = construct_resource_path + construct_query_string(query_params)
        return parse_response(@oauth_session.get(resource))
    end

    def post(body = '')
      return parse_response(@oauth_session.post(construct_resource_path, body))
    end

    def delete(query_params = {})
      resource = construct_resource_path + construct_query_string(query_params)
      return parse_response(@oauth_session.delete(resource))
    end

    def put(body = '')
      return parse_response(@oauth_session.post(construct_resource_path, body))
    end

    protected  
    def get_resource_path_segments
      return [@path_component] if @parent.nil?
      return @parent.get_resource_path_segments().push(@path_component)
    end

    def construct_resource_path
      return '/' + (get_resource_path_segments().join('/'))
    end

    def construct_query_string(params)
      return '' unless params && params.size > 0
      return '?' + params.map {|k,v| "#{k}=#{v}"}.join('&')
    end

    private
    def parse_response(response)
      puts "Class: #{response.class}"
      body = Nokogiri::XML.parse(response.body)
      case response
      when Net::HTTPSuccess
        return body
      else
        raise RetflixError.new(response.code, body)
      end
    end
  end
  
end
