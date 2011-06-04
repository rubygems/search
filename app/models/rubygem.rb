class Rubygem
  
  # TODO: Reusable DSL for configuring the index
  # id :name
  # index :name, as: %w(text name)  
  
  def initialize(attributes={})
    $solr.add({
      __id: "#{attributes[:id]} #{Rails.env}",
      __env: Rails.env
    }.merge(attributes))
  end
  
  def self.find(*args)
    if args.length == 1
      JSON.parse(
        $solr.get 'select', params: {
          q: "__id:[#{args.first} #{Rails.env}]",
          wt: "json"
        }
      )
    end
  end
  
  def self.create(attributes={})
    new(attributes).tap do |rubygem|
      rubygem.save
    end
  end
  
  def save
    $solr.commit
  end
  
  def self.search(params={})
    JSON.parse(
      $solr.get(
        "select", params: {
          defType: "dismax",
          wt: "json"
        }.merge(params)
      )
    )
  end
  
end