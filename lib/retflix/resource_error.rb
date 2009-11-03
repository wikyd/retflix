module Retflix
    
  class ResourceError < StandardError
    attr_reader :code
    attr_reader :response
    def initialize(code, response)
      @code   = code
      @response = response
    end
  end
end