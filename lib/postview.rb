$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Postview

  ROOT     = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  SETTINGS = File.join(ROOT, "settings.yml")

  require 'rubygems'
  require 'sinatra/base'
  require 'sinatra/mapping'
  require 'sinatra/mapping_helpers'
  require 'postage'
  require 'ostruct'

  autoload :Settings,    'postview/settings'
  autoload :Site,        'postview/site'
  autoload :Application, 'postview/application'

  class << self

    def version
      "0.6.0"
    end

    def tagged
      "Beta Release"
    end

    def to_s
      "#{self.name} v#{version} (#{tagged})"
    end
    alias :info :to_s

  end

end # module Postview

