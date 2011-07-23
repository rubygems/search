class WebhookController < ApplicationController
  
  def gem
    if Rubygem.create(json)
      head 200
    else
      head 400
    end
  end
  
protected

  def json
    @json ||= JSON.parse(request.body.read)
  end
  
end
