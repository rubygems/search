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
    type = name == :id ? nil : (options.delete(:as) || :text).to_sym
    solr_field_name = [name, type].compact.join("_").to_sym
    (@@fields||={})[name] = {
      as: type,
      solr_field_name: solr_field_name
    }.merge(options)
    define_method "#{name}=" do |value|
      @attributes[name] = value
    end
    define_method "#{solr_field_name}=" do |value|
      @attributes[name] = value
    end
    define_method "#{name}" do
      @attributes[name]
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
        solr_doc[options[:solr_field_name]] = attributes[name]
      end
    end
    solr_doc
  end
  
  text :info
  text :authors
  
  string :bug_tracker_uri
  string :documentation_uri
  string :gem_uri
  string :homepage_uri
  string :mailing_list_uri
  string :project_uri
  string :source_code_uri
  string :version
  string :wiki_uri
  
  name :name, boost: 2
  name :runtime_dependencies
  name :development_dependencies
  
  sint :downloads
  sint :version_downloads

  def self.find(*args)
    if args.length == 1
      json = JSON.parse(
        $solr.get 'select', params: {
          q: "__id:[#{args.first} #{Rails.env}]",
          wt: "json"
        }
      )
      json ||= {'response' => {'docs' => []}}
      json.collect do |doc|
        new(doc)
      end
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
  
  def self.dismax_qf
    @@fields.collect do |name, opts|
      [ opts[:solr_field_name],
        opts[:boost] ].compact.join("^")
    end
  end
  
  def self.search(params={})
    json = JSON.parse(
      $solr.get("select", params: {
        defType: "dismax",
        wt: "json",
        qf: dismax_qf
      }.merge(params))
    )
    json ||= {'response' => {'docs' => []}}
    json['response']['docs'].collect! do |doc|
      d = doc.dup.delete_if{|k,v| %w(__id __env).include?(k) }
      new(d)
    end
    json
  end
  
end