namespace :solr do
  
  task :run => :environment do
    system %(
      cd vendor/solr &&
      java \
        -Dsolr.solr.home=#{Rails.root.join('solr')} \
        -jar start.jar
    )
  end
  
end