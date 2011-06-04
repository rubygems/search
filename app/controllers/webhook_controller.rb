class WebhookController < ApplicationController
  
  def gem
    Rubygem.create(
      id:  "#{json['name']} #{Rails.env}",
      env: Rails.env
    )
    head 200
  end
  
protected

  def json
    @json ||= JSON.parse(request.body.read)
  end
  
end
