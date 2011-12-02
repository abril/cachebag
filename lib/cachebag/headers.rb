# encoding: UTF-8
module CacheBag
  class Headers
    attr_reader :headers
    # TODO make this a cross ruby version blank slate object
    
    def initialize(headers)
      @headers = {}
      
      headers.each do |field, value|
        @headers[normalize_field(field)] = {
                                              :value => value.strip,
                                              :original_field_name => field
                                           }
      end
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
      # to get the value of a directive
      else
        @headers.key?(method) ? @headers[method][:value] : nil
      end
    end

  private

    def normalize_field(field)
      field.to_s.downcase.gsub(/-/,"_").to_sym
    end
    
  end
end
