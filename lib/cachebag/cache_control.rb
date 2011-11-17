module CacheBag
  # Cache-Control header: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9
  #
  # Summary:
  #
  # STANDALONE_DIRECTIVES     = [:no_store, :no_transform, :only_if_cached, :public, :must_revalidate, :proxy_revalidate]
  # VALUE_DIRECTIVES          = [:max_age, :min_fresh, :s_maxage]
  # OPTIONAL_VALUE_DIRECTIVES = [:max_stale, :private, :no_cache]
  #
  # - What is cacheable (imposed by origin servers)
  #   @public: the response MAY be cached.
  #   @private: all OR part of the response MUST NOT be cached by SHARED CACHE. A non-shared cache MAY cache the response. The value indicate what info is private and shouldn't be a valid response for other users.
  #   @no-cache: without value -> cache MUST NOT use response, MUST revalidate with origin server
  #             with value    -> cache MAY use response if field names AREN'T on headers, otherwise, MUST be reavlidated
  #
  # - What may be stored by caches (imposed by agents or origin servers)
  #   @no-store: in requests or responses -> cache MUST NOT store!
  #
  # - Modifications of the Basic Expiration Mechanism (imposed by agents or origin servers)
  #   @s-maxage: the age to be considered in shared caches (ignored for local caches)
  #   @max-age: [now - last-modified > max-age => stale]. This is affected by max-stale
  #   @min-fresh: [now - last-modified > max-age - min-fresh => stale]
  #   @max-stale: [now - last-modified > max-age + max-stale => stale]. Use header Warning 110 (Response is stale) in this case
  #   If a request includes the no-cache directive, it SHOULD NOT include min-fresh, max-stale, or max-age.
  #
  # - Cache revalidation and reload controls
  #   end-to-end reload: request -> "no-cache", "Pragma: no-cache" (for retro-compatibility)
  #   specific end-to-end revalidation: request -> "max-age=0" (the first request includes a conditional)
  #   unspecified end-to-end revalidation: request -> "max-age=0" (a cache along the path includes the conditional)
  #   @only-if-cached: request -> cache SHOULD either respond using the cache, or respond with a 504 (Gateway Timeout). The request MAY be forwarded.
  #   @must-revalidate: response -> the cache MUST NOT use the entry AFTER IT BECOMES STALE for next requests
  #   @proxy-revalidate: same as above, but applied to shared caches
  #
  # - No-transform directive
  #   @no-transform: cache MUST NOT change the headers listed in http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.5.2 and the body
  #
  # - Cache control extensions
  #   extension MAY be added, without changing any semantics of the other directives
  #   cache unrecognized extensions MUST be ignored
  #
  class CacheControl
    attr_reader :value, :directives
    
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