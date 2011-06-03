class WebhookController < ApplicationController
  
  def gem
    json = JSON.parse(request.body)
    solr = RSolr.connect :url => ENV['WEBSOLR_URL']

    solr.add json.merge({
      :id => json['name'],
      
    })
    
    head 200
  end
  
end
