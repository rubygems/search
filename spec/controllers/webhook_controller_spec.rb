require 'spec_helper'

describe WebhookController do

  after :each do
    $solr.delete_by_query 'env:test'
    $solr.commit
  end

  it "should receive a payload" do
    request.env["HTTP_ACCEPT"] = "application/json"
    request.env["RAW_POST_DATA"] = {
      "name" => "rails",
      "info" => "Rails is a framework for building web-application using CGI, FCGI, mod_ruby,
               or WEBrick on top of either MySQL, PostgreSQL, SQLite, DB2, SQL Server, or 
               Oracle with eRuby- or Builder-based templates.",
      "version" => "2.3.5",
      "version_downloads" => 2451,
      "authors" => "David Heinemeier Hansson",
      "downloads" => 134451,
      "project_uri" => "http://rubygems.org/gems/rails",
      "gem_uri" => "http://rubygems.org/gems/rails-2.3.5.gem",
      "homepage_uri" => "http://www.rubyonrails.org/",
      "wiki_uri" => "http://wiki.rubyonrails.org/",
      "documentation_uri" => "http://api.rubyonrails.org/",
      "mailing_list_uri" => "http://groups.google.com/group/rubyonrails-talk",
      "source_code_uri" => "http://github.com/rails/rails",
      "bug_tracker_uri" => "http://rails.lighthouseapp.com/projects/8994-ruby-on-rails",
      "dependencies" => {
        "runtime" => [
          {
            "name" => "activesupport",
            "requirements" => ">= 2.3.5"
          }
        ],
        "development" => [ ]
      }
    }.to_json

    post :gem

    response.should be_success
    
    search = $solr.get 'select', :params => { :q => "*:*" }
    search['response']['numFound'].should == 1
    
  end

end
