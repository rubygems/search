namespace :hooks do

  rubygems_host = ENV['RAILS_ENV'] == 'production' ? "rubygems.org" : "localhost:3000"
  search_host = ENV['RAILS_ENV'] == 'production' ? "search.rubygems.org" : "search.rubygems.dev"
  auth = ENV['AUTH']
  
  task :register do
    cmd = "curl -H 'Authorization:#{auth}' " +
            "-F 'gem_name=*' -F 'url=http://#{search_host}/webhook/gem' " +
            "http://#{rubygems_host}/api/v1/web_hooks"
    puts cmd
    system cmd
  end
  
  task :fire do
    cmd = "curl -H 'Authorization:#{auth}' " +
            "-F 'gem_name=*' -F 'url=http://#{search_host}/webhook/gem' " +
            "http://#{rubygems_host}/api/v1/web_hooks/fire"
    puts cmd
    system cmd
  end
  
end