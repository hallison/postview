module Postview

class Application < Sinatra::Base

  configure do
    set :app_file, __FILE__
    set :root,     PATH
    set :static,   true

    set :settings, Settings.load
    set :site,     settings.build_site
    set :map,      settings.build_mapping
    set :page,     OpenStruct.new(:title => site.subtitle, :keywords => [])
  end

  configure :development do
    site.url = '/'
    map.root = site.url
  end

  before do
    @settings = options.settings
    @site     = options.site
    @map      = options.map
    @page     = options.page
    @tags     = @site.find.all_tags.sort
  end

  helpers do
    attr_reader :site, :page, :posts, :tags, :archive, :post, :tag, :map

    def path_to(*args)
      args.compact!
      query = args.pop if args.last.is_a?(Hash)
      path  = map.path_to(*args)
      path << "?" << build_query(query) if query
      path
    end

    def title_to(*args)
      map.path_to_title(*args)
    end
  end

  # Show only the last 10 posts.
  get map.path_to(:root) do
    @posts = @site.find.all_posts.limit(10).reverse
    @page.title, @page.keywords = @site.subtitle, %w(posts)
    erb :index
  end

  get map.path_to(:root).gsub(/\/$/,'') do
	  redirect @map.path_to(:root), 301
  end

  # Show all tags.
  get map.path_to(:tags) do
    @page.title, @page.keywords = @map.path_to_title(:tags), @tags
    erb :tags
  end

  get map.path_to(:tags, "/") do
	  redirect @map.path_to(:tags), 301
  end

  # Show archives grouped by year.
  get map.path_to(:archive) do
    @posts = @site.find_archived.all_posts.limit(10).reverse
    @page.title, @page.keywords = @map.path_to_title(:archive), @tags
    erb :archive
  end

  get map.path_to(:archive, "/") do
	  redirect @map.path_to(:archive), 301
  end

  # Show information site.
  get map.path_to(:about) do
    erb :about
  end

  get map.path_to(:about, "/") do
	  redirect @map.path_to(:about), 301
  end

  # Search posts by title or match file name.
  get map.path_to(:search) do
    @posts   = @site.find.posts(*params.values)
    @archive = @site.find_archived.posts(*params.values)
    @page.title, @page.keywords = @map.path_to_title(:search), @tags
    erb :search
  end

  # Show selected post.
  get map.path_to(:posts, ":year/:month/:day/:name") do |year, month, day, name|
    @post = @site.find.post(year, month, day, name)
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    erb :post
  end

  get map.path_to(:posts, ":year/:month/:day/:name/") do |year, month, day, name|
	  redirect @map.path_to(:posts, year, month, day, name), 301
  end

  # Show all posts by selected tag.
  get map.path_to(:tags, ":tag") do |tag|
    @tag   = @site.find.tag(tag)
    @posts = @site.find.all_posts_by_tag(tag)
    @page.title, @page.keywords = "#{@map.path_to_title(:tags)} - #{@tag.capitalize}", %(posts #{@tag}) unless @posts.empty?
    erb :tag
  end

  get map.path_to(:tags, ":tag/") do |tag|
    redirect @map.path_to(:tags, tag), 301
  end

  # Show selected post in archive.
  get map.path_to(:archive, ":year/:month/:day/:name") do |year, month, day, name|
    @post = @site.find_archived.post(year, month, day, name)
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    erb :post
  end

  get map.path_to(:archive, ":year/:month/:day/:name/") do |year, month, day, name|
	  redirect @map.path_to(:archive, year, month, day, name), 301
  end

  # Show all archived posts by selected tag.
  get map.path_to(:archive, :tags, ":tag") do |tag|
    @tag   = @site.find_archived.tag(tag)
    @posts = @site.find_archived.all_posts_by_tag(tag)
    @page.title, @page.keywords = "#{@map.path_to_title(:tags)} - #{@tag.capitalize}", %(posts #{@tag}) unless @posts.empty?
    erb :tag
  end

  get map.path_to(:archive, :tags,":tag/") do |tag|
    redirect map.path_to(:archive, :tags, tag), 301
  end

end # class Application

end # module Postview

