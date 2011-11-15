module CacheBag
  # Cache-Control header: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9
  class CacheControl
    attr_reader :value, :directives
    
    # STANDALONE_DIRECTIVES     = [:no_cache, :no_store, :no_transform, :only_if_cached, :public, :no_store, :must_revalidate, :proxy_revalidate]
    # VALUE_DIRECTIVES          = [:max_age, :min_fresh, :s_maxage]
    # OPTIONAL_VALUE_DIRECTIVES = [:max_stale, :private, :no_cache]
    VALUE_INTEGER = [:max_age, :min_fresh, :s_maxage, :max_stale]
    
    def initialize(header_value)
      @value  = header_value.strip
      @directives = {}
      parse_directives
    end
    
    def method_missing(method, *args)
      method_name = method.to_s
      # to check if a directive exists on value
      if method_name[-1,1] == '?'
        method_name = method_name.chop.to_sym
        @directives.key?(method_name)
      # to get the value of a directive
      else
        @directives[method]
      end
    end
    
  private
  
    def parse_directives
      directives = @value.split(",")
      directives.each do |d|
        key, value = d.strip.split("=")
        key = normalize(key.strip)
        @directives[key] = convert_value(key, value)
      end
    end
    
    def normalize(value)
      value.downcase.gsub(/-/,"_").to_sym
    end
    
    def convert_value(key, value)
      if value
        value = VALUE_INTEGER.include?(key) ? value.strip.to_i : value.strip.gsub(/(\A"|"\z)/,"")
      end
      value
    end
    
  end
end