$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Postview

  PATH     = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  SETTINGS = File.join(PATH, *%w(config settings.yml))

  %w(rubygems sinatra/base ostruct erb maruku rake ruby-debug).collect do |dependency|
    require dependency
  end

  require 'extensions'

  autoload :Settings,    'postview/settings'
  autoload :Mapping,     'postview/mapping'
  autoload :Site,        'postview/site'
  autoload :Finder,      'postview/finder'
  autoload :Post,        'postview/post'
  autoload :Application, 'postview/application'

  class << self

    def version
      [ 0, 3, 0, nil ].compact.join('.')
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

