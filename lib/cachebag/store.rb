# encoding: UTF-8
require "digest/md5"

module CacheBag
  autoload :MemoryStore, "cachebag/store/memory_store"
  
  class Store    
    def write(key, headers, body)
    end
    
    def read(key)
    end
    
    def delete(key)    
    end
    
    def clear
    end
    
  protected
    def hash_key(key)
      Digest::MD5.hexdigest(key)
    end  
  end
end
