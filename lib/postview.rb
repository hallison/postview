$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
# Copyright (c) 2009 Hallison Batista
#
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
# theme. To help for this, read Helpers for more informations.
#
module Postview
  # RubyGems.
  require 'rubygems' unless $LOADED_FEATURES.include? 'rubygems.rb'

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

  class << self

    # Current application path.
    def path
      @path ||= Pathname.new(Dir.pwd).expand_path
    end

    # Change current directory path for load all settings from other
    # path.
    def path=(pathname)
      @path = Pathname.new(pathname).expand_path
    end

    # Version specification loaded from +VERSION+ file.
    def version_spec
      @version_spec ||= OpenStruct.new(YAML.load_file(ROOT.join("VERSION")))
    end

    # Current version tag.
    def version_tag
      %w{major minor patch release}.map do |tag|
        version_spec.send(tag)
      end.compact.join(".")
    end

    # Version information.
    def version_summary
      "#{name.sub(/::.*/,'')} v#{version_tag} (#{version_spec.date.strftime('%B %d, %Y')}, #{version_spec.cycle})"
    end

    # About information loaded from +ABOUT+ file.
    def about_info
      @about_info ||= OpenStruct.new(YAML.load_file(File.join(ROOT, "ABOUT")))
    end

    # About text.
    def about
      <<-end_info.gsub(/^[ ]{6}/,'')
        #{version_summary}

        Copyright (C) #{version_spec.timestamp.year} #{about_info.authors.join(', ')}

        #{about_info.description}
  
        For more information, please see the project homepage
        #{about_info.homepage}. Bugs, enhancements and improvements,
        please send message to #{about_info.email}.
      end_info
    end

    # Render about text to HTML.
    def about_to_html
      Maruku.new(about).to_html
    end

  end

end # module Postview

