module CacheBag
  class MemoryStore < Store
    def initialize
      super
      @data = {}
    end
    
    def write(key, headers, body)
      super
      @data[hash_key(key)] = HttpEntry.new(key, headers, body)
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