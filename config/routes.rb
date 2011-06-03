SearchRubygems::Application.routes.draw do
  
  post '/webhook/gem' => 'webhook#gem'
  post '/webhook/gem/yank' => 'webhook#yank'
  
end
