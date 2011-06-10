class Rubygem #< Solr::Document
  
  # TODO: Reusable DSL for configuring the index
  # id :name
  # index :name, as: %w(text name)  
  
  def assign_attribute(name, value)
    @attributes[name] = value
  end
  
  def self.index(name, options={})
    name = name.to_sym
    (@@fields||={})[name] = {
      as: name == :id ? nil : (options.delete(:as) || :text).to_sym
    }.merge(options)
    define_method "#{name}=" do |value|
      @attributes[name] = value
    end
  end
  
  def to_solr
    solr_doc = {}
    solr_doc[:__id] = "#{attributes[:id]} #{Rails.env}"
    solr_doc[:__env] = Rails.env.to_s
    @@fields.each do |name, options|
      if @attributes[name] # || options[:proc]
        if name == :id
          solr_field_name = :id
        else
          solr_field_type = options[:as] || 'text'
          solr_field_name = "#{name}_#{solr_field_type}"
        end
        solr_doc[solr_field_name.to_sym] = attributes[name]
      end
    end
    solr_doc
  end
  
  index :id
  index :name, as: 'text'
  index :info
  index :version, as: 'string'
  index :version_downloads
  index :authors
  index :downloads

  index :project_uri,       as: 'string'
  index :gem_uri,           as: 'string'
  index :homepage_uri,      as: 'string'
  index :wiki_uri,          as: 'string'
  index :documentation_uri, as: 'string'
  index :mailing_list_uri,  as: 'string'
  index :source_code_uri,   as: 'string'
  index :bug_tracker_uri,   as: 'string'

  index :runtime_dependencies,     as: 'name'
  index :development_dependencies, as: 'name'
  
  attr_accessor :attributes

  def initialize(attributes={})
    @attributes = {}
    attributes.each do |name, val|
      send "#{name}=", val
    end
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
  
  def dependencies=(dependencies)
    runtime_dependencies = dependencies['runtime']
    development_dependencies = dependencies['development']
  end
  
  def save
    $solr.add(to_solr)
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