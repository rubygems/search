SearchRubygems::Application.routes.draw do

  root :to => 'search#search', :q => ''
  get '/search' => 'search#search'
  
  post '/webhook/gem' => 'webhook#gem'
  post '/webhook/gem/yank' => 'webhook#yank'
  
end
