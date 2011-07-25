# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

if Rails.env.development?
  
  Sunspot.remove_all
  Sunspot.commit

  Rails.root.join('tmp/seeds.json').open.readlines.each do |payload|
    json = JSON.parse(payload)
    begin
      Rubygem.create(json)
    rescue Exception => e
      puts "Error - #{e.message}"
      puts "\t#{json.inspect}"
    end
  end

end