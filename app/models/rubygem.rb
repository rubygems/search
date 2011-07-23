class Rubygem < ActiveRecord::Base
  
  attr_accessible :downloads, :version_downloads,
                  :name, :authors, :info,
                  :bug_tracker_uri, :documentation_uri, :gem_uri, :homepage_uri,
                  :mailing_list_uri, :project_uri, :source_code_uri, :wiki_uri
  
  searchable do
    integer :downloads
    integer :version_downloads
    
    text :name
    text :authors
    text :info
    
    string :bug_tracker_uri
    string :documentation_uri
    string :gem_uri
    string :homepage_uri
    string :mailing_list_uri
    string :project_uri
    string :source_code_uri
    string :wiki_uri
  end
  
  def self.search(params={})
    solr_response = solr_search do
      keywords params[:q]
    end
    solr_response.results
  end
  
end
