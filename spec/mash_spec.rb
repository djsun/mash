require File.join(File.dirname(__FILE__),"..","lib","mash")
require File.join(File.dirname(__FILE__),"spec_helper")

describe Mash do
  before(:each) do
    @mash = Mash.new
  end
  
  it "should inherit from hash" do
    @mash.is_a?(Hash).should be_true
  end
  
  it "should be able to set hash values through method= calls" do
    @mash.test = "abc"
    @mash["test"].should == "abc"
  end
  
  it "should be able to retrieve set values through method calls" do
    @mash["test"] = "abc"
    @mash.test.should == "abc"
  end
  
  it "should test for already set values when passed a ? method" do
    @mash.test?.should be_false
    @mash.test = "abc"
    @mash.test?.should be_true
  end
  
  it "should make all [] and []= into strings for consistency" do
    @mash["abc"] = 123
    @mash.key?('abc').should be_true
    @mash["abc"].should == 123
  end
  
  it "should have a to_s that is identical to its inspect" do
    @mash.abc = 123
    @mash.to_s.should == @mash.inspect
  end
  
  it "should return nil instead of raising an error for attribute-esque method calls" do
    @mash.abc.should be_nil
  end
  
  it "should return a Mash when passed a bang method to a non-existenct key" do
    @mash.abc!.is_a?(Mash).should be_true
  end
  
  it "should return the existing value when passed a bang method for an existing key" do
    @mash.name = "Bob"
    @mash.name!.should == "Bob"
  end
  
  it "#initializing_reader should return a Mash when passed a non-existent key" do
    @mash.initializing_reader(:abc).is_a?(Mash).should be_true
  end
  
  it "should allow for multi-level assignment through bang methods" do
    @mash.author!.name = "Michael Bleigh"
    @mash.author.should == Mash.new(:name => "Michael Bleigh")
    @mash.author!.website!.url = "http://www.mbleigh.com/"
    @mash.author.website.should == Mash.new(:url => "http://www.mbleigh.com/")
  end
  
  it "#deep_update should recursively mash mashes and hashes together" do
    @mash.first_name = "Michael"
    @mash.last_name = "Bleigh"
    @mash.details = {:email => "michael@asf.com"}.to_mash
    @mash.deep_update({:details => {:email => "michael@intridea.com"}})
    @mash.details.email.should == "michael@intridea.com"
  end
  
  it "should handle id correctly" do
    @mash.id = 100
    @mash.id.should == 100
  end

  it "should handle a buried id correctly" do
    @mash.top = { :id => 100 }
    @mash.top.id.should == 100
  end
  
  context "#initialize" do
    it "should convert an existing hash to a Mash" do
      converted = Mash.new({:abc => 123, :name => "Bob"})
      converted.abc.should == 123
      converted.name.should == "Bob"
    end
  
    it "should convert hashes recursively into mashes" do
      converted = Mash.new({:a => {:b => 1, :c => {:d => 23}}})
      converted.a.is_a?(Mash).should be_true
      converted.a.b.should == 1
      converted.a.c.d.should == 23
    end
  
    it "should convert hashes in arrays into mashes" do
      converted = Mash.new({:a => [{:b => 12}, 23]})
      converted.a.first.b.should == 12
      converted.a.last.should == 23
    end
  end
end

describe Hash do
  it "should be convertible to a Mash" do
    mash = {:some => "hash"}.to_mash
    mash.is_a?(Mash).should be_true
    mash.some.should == "hash"
  end
  
  it "#stringify_keys! should turn all keys into strings" do
    hash = {:a => "hey", 123 => "bob"}
    hash.stringify_keys!
    hash.should == {"a" => "hey", "123" => "bob"}
  end
  
  it "#stringify_keys should return a hash with stringified keys" do
    hash = {:a => "hey", 123 => "bob"}
    stringified_hash = hash.stringify_keys
    hash.should == {:a => "hey", 123 => "bob"}
    stringified_hash.should == {"a" => "hey", "123" => "bob"}
  end

  it "should handle id properly" do
    mash = {:id => 100}.to_mash
    mash.is_a?(Mash).should be_true
    mash.id.should == 100
  end

  it "should handle buried id properly" do
    mash = {:top => {:id => 100}}.to_mash
    mash.is_a?(Mash).should be_true
    mash.top.id.should == 100
  end
  
end
