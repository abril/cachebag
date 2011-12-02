# encoding: UTF-8
module CacheBag
  class HttpEntry
    
    attr_reader :url, :headers, :body
    
    def initialize(url, headers, body)
      @url     = url
      @body    = body
      @headers = (headers.class == Headers) ? headers : Headers.new(headers)
      
      add_missing_cache_headers
    end

    def age
      0
    end
    
    def freshness_lifetime
      if headers.cache_control.max_age? # since we are a local cache, we can ignore s-maxage directive (http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9.3)
        headers.cache_control.max_age
      elsif headers.expires?
        headers.expires - headers.date
      else
        headers.cache_control.directives[:max_age] = 0
      end
    end
    
    def fresh?
      freshness_lifetime > age
    end
    
    def stale?
      !fresh?
    end
  
  private
  
    def add_missing_cache_headers
      headers["Cache-Control"] = "" unless headers.cache_control?
    end
  
  end
end
