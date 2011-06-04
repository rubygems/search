require 'spec_helper'

describe Rubygem do
  
  it "should append the environment to its internal id" do
    Rubygem.create({ id: "foobar" })
    search = $solr.get 'select', params: { q: '__id:[foobar test]' }
    search['response']['numFound'].should == 1
  end
  
  it "should set an environment field" do
    Rubygem.create(id: 'bar')
    search = $solr.get 'select', params: { q: '*:*', fq: "__env:test" }
    search['response']['numFound'].should > 0
  end
  
  describe "#find" do
    it "should find a document by its id" do
      Rubygem.create({ id: 'foobar' })
      Rubygem.find('foobar').should_not be_blank
    end
  end
  
  
end