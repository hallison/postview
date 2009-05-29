#begin
#  require 'sinatra'
#rescue LoadError
#  # TODO: Improve this instructions
#  user_gem_home = File.join(ENV["HOME"],*%w(.gem ruby 1.8 gems))
#  rack          = Dir[File.join(user_gem_home, *%w(rack* lib rack))].sort.last
#  sinatra       = Dir[File.join(user_gem_home, *%w(sinatra* lib sinatra))].sort.last
#  require rack
#  require sinatra
#end
require 'lib/postview'

run Postview::Application

