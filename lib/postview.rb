# Copyright (c) 2009 Hallison Batista
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# Postview - The minimalist blogware and static page generator.
#
# == Configuration
#
# After create your blog, edit <tt>config/settings.yml</tt> file.
#
# *site*::        Attributes for your site.
#                 * *title*
#                 * *subtitle*
#                 * *author*
#                 * *email*
#                 * *domain* for connect by FTP.
#                 * *directory*, remote. This attribute will be used to synchronize your posts.
#                 * *theme*
# *sections*::    Attributes for sections (routes) used in site.
#                 * *root* for main section
#                 * *posts*
#                 * *tags*
#                 * *archive*
#                 * *drafts*
#                 * *search*
#                 * *about*
# *directories*:: Attributes for paths to post files.
#                 * *posts*
#                 * *archive*
#                 * *drafts*
#
# == Themes
#
# Default theme is generated in <tt>themes/default</tt>. Change or migrate your favorite
# theme.
#
module Postview

  # RubyGems.
  require 'rubygems'

  # Core requires.
  require 'optparse' 
  require 'pathname'
  require 'ostruct'

  # 3rd part libraries/projects.
  require 'sinatra/base' unless defined? ::Sinatra::Base
  require 'sinatra/mapping' unless defined? ::Sinatra::Mapping
  require 'postage' unless defined? ::Postage

  # Internal requires
  require 'postview/patches' if RUBY_VERSION < "1.8.7"

  ROOT = Pathname.new("#{File.dirname(__FILE__)}/..").expand_path
  PATH = Pathname.new(".").expand_path

  # Auto-load all internal requires.
  autoload :About,         'postview/about'
  autoload :Version,       'postview/version'

  autoload :Settings,      'postview/settings'
  autoload :Site,          'postview/site'
  autoload :Helpers,       'postview/helpers'
  autoload :Application,   'postview/application'
  autoload :CLI,           'postview/cli'

end # module Postview

