class Rubygem
  
  def initialize(attributes={})
    $solr.add({
      __id: "#{attributes[:id]} #{Rails.env}",
      __env: Rails.env
    }.merge(attributes))
  end
  
  def self.find(*args)
    if args.length == 1
      $solr.get 'select', params: { q: "__id:[#{args.first} #{Rails.env}]" }
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
  
end