namespace :solr do
  
  task :run => :environment do
    
    solr_home  = Rails.root.join("solr")
    data_dir   = Rails.root.join("solr/data", Rails.env)
    solr_logs  = Rails.root.join("solr/conf/logging.properties")
    jetty_logs = Rails.root.join("log")
    port       = 8982
    
    system %(
      cd vendor/solr &&
      java \
        -Dsolr.solr.home=#{solr_home} \
        -Dsolr.data.dir=#{data_dir} \
        -Djava.util.logging.config.file=#{solr_logs} \
        -Djetty.port=#{port} \
        -Djetty.logs=#{jetty_logs} \
        -jar start.jar
    )
  end
  
end