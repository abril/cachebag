# encoding: UTF-8
module CacheBag
  class Headers
    instance_methods.each do |m|
      undef_method m unless m.to_s =~ /^method_missing$|^respond_to\?$|^__|object_id/ 
    end # not using BasicObject for retro-compatibility
    
    attr_reader :headers
    
    def initialize(original_headers)
      @headers = {}
      
      original_headers.each do |field, value|
        self[field] = value
      end
    end
    
    def []=(field, value)
      @headers[normalize(field)] = {
                                      :value => value.strip,
                                      :original_field_name => field
                                   }      
    end
    
    def method_missing(method, *args)
      method_name = method.to_s
      
      # to check if a header exists on value
      if method_name.end_with?("?")
        method_name = method_name.chop.to_sym
        @headers.key?(method_name)
      # to get the original field name of a header  
      elsif method_name.end_with?("!")
        method_name = method_name.chop.to_sym
        @headers.key?(method_name) ? @headers[method_name][:original_field_name] : nil
      # to get the value of a header
      else
        @headers.key?(method) ? @headers[method][:value] : nil
      end
    end

  private

    def normalize(field)
      field.to_s.downcase.gsub(/-/,"_").to_sym
    end
    
  end
end
