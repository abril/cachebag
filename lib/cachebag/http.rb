# encoding: UTF-8
module CacheBag
  autoload :Response, "cachebag/http/response"
  
  class Http
    
    attr_reader :url, :headers, :body
    
    def initialize(url, headers, body)
      @url     = url
      @body    = body
      @headers = (headers.class == Headers) ? headers : Headers.new(headers)
    end

    def now
      Time.now
    end
  
  end
end
