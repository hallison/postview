$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Postview

  ROOT     = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  SETTINGS = File.join(ROOT, *%w(config settings.yml))

  %w[rubygems sinatra/base sinatra/mapping sinatra/mapping_helpers ostruct postage].collect do |dependency|
    require dependency
  end

  autoload :Settings,    'postview/settings'
  autoload :Site,        'postview/site'
  autoload :Application, 'postview/application'

  class << self

    def version
      [ 0, 5, 0, nil ].compact.join('.')
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

