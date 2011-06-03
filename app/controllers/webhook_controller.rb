class WebhookController < ApplicationController
  
  def gem
    json = JSON.parse(request.body.read)
    
    $solr.add(
      { id:  "#{json['name']} #{Rails.env}",
        env: Rails.env },
      add_attributes: { commitWithin: 0 }
    )
    
    head 200
  end
  
end
