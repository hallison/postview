#@ --- 
#@ :tag: 0.10.0
#@ :date: 2010-02-10
#@ :milestone: Beta
#@ :timestamp: 2009-08-24 07:46:28 -04:00

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# = Postview - The minimalist blogware and static page generator
#
# == Configuration
#
# After create your blog, edit <tt>config/settings.yml</tt> file.
#
# [*blog*]        Attributes for your site.
#                 * *title*
#                 * *subtitle*
#                 * *author*
#                 * *email*
#                 * *domain* for connect by FTP.
#                 * *directory*, remote. This attribute will be used to synchronize your posts.
#                 * *theme*
# [*sections*]    Attributes for sections (routes) used in site.
#                 * *root* for main section
#                 * *posts*
#                 * *tags*
#                 * *archive*
#                 * *drafts*
#                 * *search*
#                 * *about*
# [*directories*] Attributes for paths to post files.
#                 * *posts*
#                 * *archive*
#                 * *drafts*
#
# == Themes
#
# Default theme is generated in <tt>themes/default</tt>. Change or migrate your favorite
# theme. To help for this, read Helpers for more informations.
#
module Postview
  # RubyGems.
  require 'rubygems' unless $LOADED_FEATURES.include? 'rubygems.rb'

  # Core requires.
  require 'optparse'
  require 'pathname'
  require 'ostruct'
  require 'yaml'

  # 3rd part libraries/projects.
  require 'sinatra/base' unless defined? ::Sinatra::Base
  require 'sinatra/mapping' unless defined? ::Sinatra::Mapping

  # Internal requires
  require 'postview/compatibility' if RUBY_VERSION < "1.8.7"
  require 'postview/extensions'

  # Root path for Postview source.
  ROOT = Pathname.new("#{File.dirname(__FILE__)}/..").expand_path.freeze

  # Auto-load all internal requires.
  autoload :Settings,       'postview/settings'
  autoload :Site,           'postview/site'
  autoload :Helpers,        'postview/helpers'
  autoload :Authentication, 'postview/authentication'
  autoload :Application,    'postview/application'
  autoload :CLI,            'postview/cli'

  # Current version
  def self.version
    @version ||= Version.current
  end

  # Base object. The purpose of this object is initialize other using
  # hash attributes.
  class Base #:nodoc:
    def initialize(attributes = {})
      attributes.each do |attribute, value|
        send("#{attribute}=", value) if respond_to? "#{attribute}="
      end
    end
  end # class Base

  # Postview configuration class. The purpose of this class is set all
  # values that will be shared by all classes.
  # The configuration is based in the following attributes:
  #
  # [*blog*]        That set all attributes for blog.
  # [*directories*] Set all directories for files.
  # [*sections*]    Set all path names that will be mapped.
  #
  # Example:
  #
  #   Postview::Configuration.new do |config|
  #     config.set :blog do |blog|
  #       blog.title     = "Blog on duck"
  #       blog.subtitle  = "My personal blog"
  #       blog.author    = "Anibal Lecter"
  #       blog.email     = "anibal@al-brainstorm.com"
  #       blog.domain    = "al-brainstorm.com"
  #       blog.directory = "/var/www/al-brainstorm.com"
  #       blog.theme     = "blood-lines"
  #     end
  #
  #     config.set :directories do |path|
  #       path.posts   = "articles"
  #       path.archive = "articles/archive"
  #       path.drafts  = "articles/drafts"
  #     end
  #
  #     config.set :sections do |section|
  #       section.root    = ""
  #       section.posts   = "articles"
  #       section.drafts  = "drafts"
  #       section.archive = "archive"
  #     end
  #   end
  class Configuration < Base

    class EmptyError < Exception; end

    # Default values.
    DEFAULTS = {
      :site => {
        :title     => "Postview",
        :subtitle  => "Post your articles",
        :author    => "Postview",
        :email     => "postview@example.com",
        :domain    => "example.com",
        :directory => "/var/www/example",
        :theme     => "default",
        :token     => "e44257415827b00557ae5505f93e112d6158c4ba3c567aefbbff47288c6bf7cd" # Password: admin
      },
      :directories => {
        :posts   => "posts",
        :drafts  => "posts/drafts",
        :themes  => "themes"
      },
      :sections => {
        :root      => "/",
        :posts     => "/posts",
        :tags      => "/tags",
        :archive   => "/archive",
        :drafts    => "/drafts",
        :search    => "/search",
        :about     => "/about",
        :dashboard => "/dashboard"
      }
    }

    # Base path for application.
    attr_reader :basepath

    # Criates a new Postview::Configuration.
    def initialize(&block) #:yields:config
      initialize_default_values
      yield self
    end

    # Configures directory paths. Directories that be used for load files.
    def directories
      return @directories unless block_given?
      yield @directories
      @directories.members.map do |path|
        @directories[path] = Pathname.new(@directories[path]).expand_path
      end
    end
    alias :directory_for :directories

    # Configures the site attributes.
    def site(&block)
      return @site unless block_given?
      yield @site
    end

    # Section names that be used in mapping routes into application.
    # Configures the section paths to map routes.
    def sections(&block)
      return @sections unless block_given?
      yield @sections
      root = @sections.root
      @sections.members.map do |name|
        @sections[name] = "/#{root}/#{@sections[name]}".squeeze("/")
      end
      @sections.root = "/#{root}".squeeze("/")
      @sections
    end
    alias :url_for :sections

    def self.load(attributes = {})
      new do |config|
        config.directories.setup(attributes[:directories]) if attributes.has_key? :directories
        config.site.setup(attributes[:site]) if attributes.has_key? :site
        config.sections.setup(attributes[:sections]) if attributes.has_key? :sections
      end
    end

    def self.load_file(filename)
      yaml = YAML.load_file(filename)
      raise EmptyError, "The file '#{filename}' is empty or not exist." unless yaml
      load(yaml)
    end

  private

    # Just initialize all attributes with default values.
    def initialize_default_values
      DEFAULTS.map do |property, defaults|
        self.instance_variable_set("@#{property}", Struct.new(*defaults.keys).new)
        attribute = self.instance_variable_get("@#{property}")
        def attribute.setup(attributes)
          attributes.map{ |member, value| self[member] = value }
        end
        attribute.setup(defaults)
      end
    end

  end # class Configuration

  class Version < Base #:nodoc:

    FILE = Pathname.new(__FILE__).freeze

    attr_accessor :tag, :date, :milestone
    attr_reader :timestamp

    def initialize(attributes = {})
      super(attributes)
      @timestamp = attributes[:timestamp]
    end

    def to_hash
      [:tag, :date, :milestone, :timestamp].inject({}) do |hash, key|
        hash[key] = send(key)
        hash
      end
    end

    def save!
      @date = Date.today
      source = FILE.readlines
      source[0..4] = self.to_hash.to_yaml.to_s.gsub(/^/, '#@ ')
      FILE.open("w+") do |file|
        file << source.join("")
      end
      self
    end

    class << self
      def current
        yaml = FILE.readlines[0..4].
                 join("").
                 gsub(/\#@ /,'')
        new(YAML.load(yaml))
      end

      def to_s
        name.match /(.*?)::.*/
        "#{$1} v#{current.tag}, #{current.date} (#{current.milestone})"
      end
    end # class self

  end

end # module Postview

