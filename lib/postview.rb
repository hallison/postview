$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

module Postview

  PATH = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  %w(rubygems sinatra/base erb maruku rake ruby-debug).collect do |dependency|
    require dependency
  end

  require 'extensions'

  autoload :Site,        'postview/site'
  autoload :Application, 'postview/application'

end # module Postview

