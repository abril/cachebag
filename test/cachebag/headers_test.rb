# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

describe CacheBag::Headers do
  
  it "should instantiate a new headers object with a Hash" do
    headers = {}
    obj = CacheBag::Headers.new(headers)
    
    obj.must_be_kind_of(CacheBag::Headers)
  end
  
  it "should accept empty headers" do
    headers = {}
    obj = CacheBag::Headers.new(headers)
    
    obj.headers.keys.size.must_equal(0)
  end
  
  it "should provide helper methods to headers fields" do
    headers = { 
                "Content-Type" => "application/json", 
                "Pragma"       => "no-cache" 
              }
    obj = CacheBag::Headers.new(headers)
    
    obj.etag?.must_equal(false)
    obj.etag.must_be_nil
    obj.content_type?.must_equal(true)
    obj.content_type.must_equal("application/json")
    obj.pragma?.must_equal(true)
    obj.pragma.must_equal("no-cache")
  end
  
  it "should keep the original names of headers fields" do
    headers = { 
                "Content-Type" => "application/json", 
                "ETag"         => "8038c7e58223d887251bfefeb4659432fddf9731" 
              }
    obj = CacheBag::Headers.new(headers)
    
    obj.etag!.must_equal("ETag")
    obj.content_type!.must_equal("Content-Type")
    obj.pragma!.must_be_nil
  end
end
