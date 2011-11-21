# encoding: UTF-8
module CacheBag
  class Base
    
    STORES = {
      :memory_store => :MemoryStore # as symbol, to avoid unnecessary loads for unused stores
    }
    
    def initialize(options = {})
      @store = CacheBag.const_get(STORES[(options[:store] || :memory_store)]).new
    end

    def store
      @store
    end
    
    def request(method, url, headers = {}, body = nil)
      raise ArgumentError, "You must pass a block containing the next steps for doing the request." unless block_given?
      
      http_date = Time.now.httpdate
      do_request = false
      
      if entry = @store.read(url)
        last_modified = entry[:headers]["Last-Modified"]
        etag          = entry[:headers]["ETag"]
      else
        do_request = true
      end
      
      response = yield(method, url, headers, body) if do_request
      #cached_content_unless_stale(url, headers) || cache_content!(method, url, headers, body, &block)
      
      #TODO: response without etag and last modified, don't store it
    end
  end
end
