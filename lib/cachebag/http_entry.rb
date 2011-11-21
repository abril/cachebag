# encoding: UTF-8
module CacheBag
  class HttpEntry
    
    attr_reader :url, :headers, :body
    
    def initialize(url, headers, body)
      @url     = url
      @body    = body
      @headers = {}
      %w(Last-Modified Cache-Control ETag Expires Pragma Vary Content-Type).each do |item|
        @headers[item] = headers[item]
      end
    end
    
    #TODO verify the need of refresh the headers and its parsed values
    
    def last_modified
      parsed[:last_modified] ||= @headers["Last-Modified"] ? Time.parse(@headers["Last-Modified"]) : nil
    end
    
    def etag
      parsed[:etag] ||= @headers["ETag"]
    end
    
    def age(date)
      last_modified ? (date - last_modified).to_i : nil
    end
    
    def cache_control_max_age
      maxage = @headers["Cache-Control"].split(",").select {|i| i.include?("max-age=") }.first.strip!
      maxage ? maxage.sub(/max-age=/, "").to_i : nil
    end
    
    def cache_control_public?
      
    end
    
  private
  
    def parsed
      @parsed ||= {}
    end
    
  end
end
