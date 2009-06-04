module Postview

class Application < Sinatra::Base

  configure do
    set :app_file, __FILE__
    set :root,     PATH
    set :static,   true

    set :settings, Settings.load
    set :site,     settings.build_site
    set :page,     { :title => site.subtitle, :keywords => [] }
    set :paths,    settings.paths
  end

  configure :development do
    site.url = '/'
  end

  before do
    @settings = options.settings
    @site     = options.site
    @page     = options.page
    @paths    = options.paths
    @tags     = @site.find.all_tags.sort
  end

  helpers do
    attr_reader :site, :page, :posts, :tags, :archive, :post, :tag, :paths

    def path_to(name, object = nil)
      return "/#{(paths[name] || name)}/#{object}" if object
      "/#{(paths[name] || name)}"
    end

    def title_to(key, *args)
      "#{(paths[key] || key).capitalize} #{args.join(' ')}"
    end
  end

  # Show only the last 10 posts.
  get %{/} do
    @posts = @site.find.all_posts.limit(10).reverse
    @page.replace(:title => @site.subtitle, :keywords => %w(posts))
    erb :index
  end

  # Show all tags.
  get %{/#{paths[:tags]}} do
    @page.replace(:title => paths[:tags].capitalize, :keywords => @tags)
    erb :tags
  end

  # Show archives grouped by year.
  get %{/#{paths[:archive]}} do
    @posts = @site.find_archived.all_posts.limit(10).reverse
    @page.replace(:title => paths[:archive].capitalize, :keywords => @tags)
    erb :archive
  end

  # Show information site.
  get %{/#{paths[:about]}} do
    erb :about
  end

  # Search posts by title or match file name.
  get %{/#{paths[:search]}} do
    @posts   = @site.find.posts(*params.values)
    @archive = @site.find_archived.posts(*params.values)
    @page.replace(:title => paths[:search].capitalize, :keywords => @tags)
    erb :search
  end

  # Show selected post in archive.
  get %r{/#{paths[:archive]}/(\d{4})/(\d{2})/(\d{2})/(.*)} do |year, month, day, name|
    @post = @site.find_archived.post(year, month, day, name)
    @page.replace(:title => @post.title, :keywords => @post.tags.join(' '))
    erb :post
  end

  # Show selected post.
  get %r{/#{paths[:posts]}/(\d{4})/(\d{2})/(\d{2})/(.*)} do |year, month, day, name|
    @post = @site.find.post(year, month, day, name)
    @page.replace(:title => @post.title, :keywords => @post.tags.join(' '))
    erb :post
  end

  # Show all posts by selected tag.
  get %{/#{paths[:tags]}/:tag} do |tag|
    @tag   = @site.find.tag(tag)
    @posts = @site.find.all_posts_by_tag(tag)
    @page.replace(:title => "#{paths[:tags].capitalize} - #{@tag.capitalize}", :keywords => %(posts #{@tag})) unless @posts.empty?
    erb :tag
  end

  # Show all archived posts by selected tag.
  get %{/#{paths[:archive]}/#{paths[:tags]}/:tag} do |tag|
    @tag   = @site.find_archived.tag(tag)
    @posts = @site.find_archived.all_posts_by_tag(tag)
    @page.replace(:title => "#{paths[:tags].capitalize} - #{@tag.capitalize}", :keywords => %(posts #{@tag})) unless @posts.empty?
    erb :tag
  end

end # class Application

end # module Postview

