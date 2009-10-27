module Postview

module Application

# Copyright (c) 2009 Hallison Batista
class Setup < Sinatra::Base #:nodoc: all

  register Sinatra::Mapping

  configure do
    set :settings, Postview::Settings.load
    set :site, settings.build_site
    set :page, settings.build_page
    set :root, Postview::ROOT
    set :public, root.join("lib/postview/application/setup/public")
    set :views, root.join("lib/postview/application/setup/views")

    map :root
    map :save
  end

  helpers do
    attr_reader :page, :settings
  end

  before do
    @settings ||= options.settings
    @page = options.page
    @page.title = "Setup"
  end

  # Show all information for site.
  get root_path do
    erb :index
  end

  post save_path do
    @settings = Postview::Settings.new :site => params[:site],
                                       :sections => params[:sections],
                                       :directories => params[:directories]
    if password = params[:password]
      @settings.site[:token] = Postview::Site::tokenize(params[:site][:author], params[:password], params[:site][:domain])
    end
    erb :index
  end

end # class Setup

end # module Application

end # module Postview

