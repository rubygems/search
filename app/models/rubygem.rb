class Rubygem #< Solr::Document

  attr_accessor :attributes
  
  def initialize(attributes={})
    @attributes = {}
    attributes.each do |name, val|
      send "#{name}=", val
    end
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

  DYNAMIC_FIELD = /dynamicField name="\*_([^"]+)".*type="([^"]+)"/
  FIELD         = /field name="([^_][^"]*)".*type="([^"]+)"/

  class << self
    Rails.root.join('solr/conf/schema.xml').open do |schema|
      @@fields ||= {}
      schema.readlines.each do |line|
        case line
        when DYNAMIC_FIELD
          # define a class method to specify other fields of this type
          field_suffix = $1
          field_type = $2
          define_method field_suffix do |name, options={}|
            index name, {as: field_suffix}
          end
        end
      end
    end
  end
  
  Rails.root.join('solr/conf/schema.xml').open do |schema|
    @@fields ||= {}
    schema.readlines.each do |line|
      case line
      when FIELD
        # define an instance getter and setter for this specific field
        field_name = $1
        field_type = $2
        index field_name, as: field_type
      end
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
  
  index :authors
  index :downloads
  index :id
  index :info
  index :version_downloads

  string :version
  text :name
  
  string :project_uri
  string :gem_uri
  string :homepage_uri
  string :wiki_uri
  string :documentation_uri
  string :mailing_list_uri
  string :source_code_uri
  string :bug_tracker_uri
  
  name :runtime_dependencies
  name :development_dependencies
  
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