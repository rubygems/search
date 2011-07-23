require 'spec_helper'

describe Rubygem do
  
  let :rubygem_payload do
    {
      dependencies: {
        runtime: [
          { name: "nokogiri", requirements: ">= 0"},
          { name: "sunspot", requirements: "= 1.2.1" } ],
        development: [
          { name: "rspec", requirements: "~> 1.2" },
          { name: "rspec-rails", requirements: "~> 1.2" }]
      },
      name: "sunspot_rails",
      downloads: 0,
      info: "Sunspot::Rails is an extension to the Sunspot library for Solr search.\nSunspot::Rails adds integration between Sunspot and ActiveRecord, including\ndefining search and indexing related methods on ActiveRecord models themselves,\nrunning a Sunspot-compatible Solr instance for development and test\nenvironments, and automatically commit Solr index changes at the end of each\nRails request.\n",
      version_downloads: 0,
      version: "1.2.1",
      homepage_uri: "http://github.com/outoftime/sunspot_rails",
      bug_tracker_uri: nil,
      source_code_uri: nil,
      gem_uri: "http://localhost/gems/sunspot_rails-1.2.1.gem",
      project_uri: "http://localhost/gems/sunspot_rails",
      authors: "Mat Brown, Peer Allan, Michael Moen, Benjamin Krause, Adam Salter, Brandon Keepers, Paul Canavese, John Eberly, Gert Thiel",
      mailing_list_uri: nil,
      documentation_uri: nil,
      wiki_uri: nil
    }
  end
  
  describe "#search" do
    before :all do
      Rubygem.create(rubygem_payload)
      Sunspot.commit
    end

    after :all do
      Sunspot.remove_all
      Sunspot.commit
    end
    
    it "should find documents with a :q param" do
      Rubygem.search(:q => 'sunspot').should_not be_blank
    end
  end
  
end