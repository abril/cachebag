# encoding: UTF-8
module CacheBag
  class Response < Http 
    
    attr_accessor :response_time, :request_time
    
    def initialize(url, headers, body, request_time, response_time)
      super(url, headers, body)
      
      @request_time  = request_time
      @response_time = response_time
      
      add_missing_cache_headers
    end

    # http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.2.3    
    def age
      apparent_age           = [0, (@response_time - headers.date)].max
      corrected_received_age = [apparent_age, (headers.age || 0)].max
      response_delay         = @response_time - @request_time
      corrected_initial_age  = corrected_received_age + response_delay
      resident_time          = self.now - @response_time
      
      return (corrected_initial_age + resident_time).to_i
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
