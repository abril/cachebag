module CacheBag
  class Base
    
    STORES = {
      :memory_store => :MemoryStore
    }
    
    def initialize(options = {})
      @store = CacheBag.const_get(STORES[(options[:store] || :memory_store)]).new
    end

    def store
      @store
    end
    
  end
end
