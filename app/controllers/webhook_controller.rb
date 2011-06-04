class WebhookController < ApplicationController
  
  def gem
    Rubygem.create(
      id: json['name']
    )
    head 200
  end
  
protected

  def json
    @json ||= JSON.parse(request.body.read)
  end
  
end
