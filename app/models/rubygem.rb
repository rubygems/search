class Rubygem < ActiveRecord::Base
  
  attr_accessible :name, :authors, :info, :version,
                  :downloads, :version_downloads, :dependencies,
                  :bug_tracker_uri, :documentation_uri, :gem_uri, :homepage_uri,
                  :mailing_list_uri, :project_uri, :source_code_uri, :wiki_uri
  
  searchable do
    text :name
    text :authors
    text :info

    text :dependencies_runtime
    text :dependencies_development

    string :version
    integer :downloads
    integer :version_downloads
    
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
    solr_search do
      keywords params[:q]
    end
  end
  
  def dependencies=(json)
    self.dependencies_runtime     = json['runtime'].collect{ |d| d['name'] }.join(' ')
    self.dependencies_development = json['development'].collect{ |d| d['name'] }.join(' ')
  end
  
end
