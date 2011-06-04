class Rubygem
  
  def initialize(attributes={})
    $solr.add(attributes)
  end
  
  def self.create(attributes={})
    new(attributes).tap do |g|
      g.save
    end
  end
  
  def save
    $solr.commit
  end
  
end