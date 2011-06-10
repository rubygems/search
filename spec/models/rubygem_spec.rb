require 'spec_helper'

describe Rubygem do
  
  describe "#create" do
    before :all do
      Rubygem.create({ id: "foobar" })
    end
    
    after :all do
      $solr.delete_by_query '*:*'
      $solr.commit
    end
    
    it "should append the environment to its internal id" do
      search = $solr.get 'select', params: { q: '__id:[foobar test]' }
      search['response']['numFound'].should == 1
    end

    it "should set an environment field" do
      search = $solr.get 'select', params: { q: 'id:foobar', fq: "__env:test" }
      search['response']['numFound'].should == 1
    end
  end
  
  describe "#find" do
    before :all do
      Rubygem.create({ id: 'foobar' })
    end

    after :all do
      $solr.delete_by_query '*:*'
      $solr.commit
    end
    
    it "should find a document by its id" do
      Rubygem.find('foobar').should_not be_blank
    end
  end
  
  describe "#to_solr" do
    before :all do
      @rubygem = Rubygem.new({
        id: 'rails',
        name: 'rails',
        version: '1.2.3'
      })
    end
    it "should contain all of the defined fields" do
      solr_doc = @rubygem.to_solr
      solr_doc[:id].should == 'rails'
      solr_doc[:name_text].should == 'rails'
      solr_doc[:version_string].should == '1.2.3'
    end
    it "should not contain nil valued fields (or convince nz otherwise)" do
      @rubygem.to_solr.keys.should_not include(:bug_tracker_uri_uri)
      @rubygem.to_solr.keys.should_not include(:bug_tracker_uri_string)
    end
  end
  
  
end