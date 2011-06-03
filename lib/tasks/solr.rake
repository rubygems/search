namespace :solr do
  
  task :run => :environment do
    solr_port = {'test' => 8981, 'development' => 8982 }[Rails.env] || 8983
    system %(
      cd vendor/solr &&
      java \
        -Dsolr.solr.home=#{Rails.root.join('solr')} \
        -Dsolr.data.dir=#{Rails.root.join('solr/data', Rails.env)} \
        -Djava.util.logging.config.file=#{Rails.root.join('solr/conf/logging.properties')} \
        -Djetty.port=#{solr_port} \
        -jar start.jar
    )
  end
  
end