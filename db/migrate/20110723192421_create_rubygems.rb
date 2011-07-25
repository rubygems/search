class CreateRubygems < ActiveRecord::Migration
  def change
    create_table :rubygems do |t|
      t.string :name
      t.string :authors
      t.string :info
      t.string :version

      t.integer :downloads
      t.integer :version_downloads
      
      t.string :dependencies_runtime
      t.string :dependencies_development
      
      t.string :bug_tracker_uri
      t.string :documentation_uri
      t.string :gem_uri
      t.string :homepage_uri
      t.string :mailing_list_uri
      t.string :project_uri
      t.string :source_code_uri
      t.string :wiki_uri
      
      t.timestamps
    end
  end
end
