$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Postview

  PATH     = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  SETTINGS = File.join(PATH, *%w(config settings.yml))

  %w[rubygems sinatra/base ostruct postage].collect do |dependency|
    require dependency
  end

  %w[ruby-debug].map do |optional|
    require optional
  end

  autoload :Settings,    'postview/settings'
  autoload :Mapping,     'postview/mapping'
  autoload :Site,        'postview/site'
  autoload :Application, 'postview/application'

  class << self

    def version
      [ 0, 4, 0, nil ].compact.join('.')
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

