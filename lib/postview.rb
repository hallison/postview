$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Postview

  PATH     = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  SETTINGS = File.join(PATH, *%w(config settings.yml))

  %w(rubygems sinatra/base erb maruku rake ruby-debug).collect do |dependency|
    require dependency
  end

  require 'extensions'

  autoload :Settings,    'postview/settings'
  autoload :Finder,      'postview/finder'
  autoload :Site,        'postview/site'
  autoload :Post,        'postview/post'
  autoload :Application, 'postview/application'

end # module Postview

