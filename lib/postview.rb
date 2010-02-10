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
  require 'postage' unless defined? ::Postage

  # Internal requires
  require 'postview/compatibility' if RUBY_VERSION < "1.8.7"
  require 'postview/extensions'

  # Root path for Postview source.
  ROOT = Pathname.new("#{File.dirname(__FILE__)}/..").expand_path

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

  class Config < Base
    # Current application path.
    attr_reader :path

    # Site attributes.
    attr_reader :site

    # Directories that be used for load files.
    attr_reader :directories

    # Section names that be used in mapping routes into application.
    attr_reader :sections

    # Criates a new configuration.
    def initialize(attributes = {}) #:yields:config
      super(attributes)
      yield self if block_given?
    end

    # Change current directory path for load all settings from other
    # path.
    def path=(pathname)
      @path = Pathname.new(pathname).expand_path
    end
  end # class Config

  class Version < Base #:nodoc:

    FILE = Pathname.new(__FILE__)

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

