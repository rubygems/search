namespace :solr do
  
  task :run => :environment do
    
    jar_home   = "vendor/solr"
    solr_home  = Rails.root.join("solr")
    data_dir   = Rails.root.join("solr/data", Rails.env)
    solr_logs  = Rails.root.join("solr/conf/logging.properties")
    jetty_logs = Rails.root.join("log")
    port       = Rails.env.test? ? 8981 : 8982
    
    system %(
      cd #{jar_home} &&
      java \
        -Djava.util.logging.config.file=#{solr_logs} \
        -Djetty.logs=#{jetty_logs} \
        -Djetty.port=#{port} \
        -Dsolr.data.dir=#{data_dir} \
        -Dsolr.solr.home=#{solr_home} \
        -jar start.jar
    )
  end
  
end