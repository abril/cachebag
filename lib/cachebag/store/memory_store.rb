module CacheBag
  class MemoryStore < Store
    def initialize
      super
      @data = {}
    end
    
    def write(key, headers = {}, body = nil)
      super
      @data[hash_key(key)] = {
                                :headers => headers,
                                :body => nil,
                                :url => key
                             }
    end
    
    def read(key)
      super
      @data[hash_key(key)]
    end
    
    def delete(key)
      super
      @data.delete(hash_key(key))
    end
    
    def clear
      super
      @data = {}
    end
  end
end