$solr = RSolr.connect(
  :url => ENV['WEBSOLR_URL'] || 'http://localhost:8982/solr'
)
