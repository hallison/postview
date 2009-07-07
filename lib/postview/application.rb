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

  # Show only the last 5 posts.
  get map.path_to(:root) do
    @posts = @site.find.all_posts.limit(5).reverse
    @page.title, @page.keywords = @site.subtitle, %w(posts)
    show :posts, :url => :posts
  end

  get map.path_to(:root).gsub(/\/$/,'') do
	  redirect @map.path_to(:root), 301
  end

  # Show all posts.
  get map.path_to(:posts) do
    @posts = @site.find.all_posts.reverse
    @page.title, @page.keywords = @map.path_to_title(:posts), @tags
    show :posts, :url => :posts
  end

  get map.path_to(:posts, "/") do
    redirect @map.path_to(:posts), 301
  end

  # Show selected post.
  get map.path_to(:posts, ":year/:month/:day/:name") do |year, month, day, name|
    @post = @site.find.post(year, month, day, name)
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :post, :url => :posts
  end

  get map.path_to(:posts, ":year/:month/:day/:name/") do |year, month, day, name|
	  redirect @map.path_to(:posts, year, month, day, name), 301
  end

  # Show all tags.
  get map.path_to(:tags) do
    @page.title, @page.keywords = @map.path_to_title(:tags), @tags
    show :tags
  end

  get map.path_to(:tags, "/") do
	  redirect @map.path_to(:tags), 301
  end

  # Show all posts by selected tag.
  get map.path_to(:tags, ":tag") do |tag|
    @tag   = @site.find.tag(tag)
    @posts = @site.find.all_posts_by_tag(tag)
    @page.title, @page.keywords = "#{@map.path_to_title(:tags)} - #{@tag.capitalize}", %(posts #{@tag}) unless @posts.empty?
    show :tag
  end

  get map.path_to(:tags, ":tag/") do |tag|
    redirect @map.path_to(:tags, tag), 301
  end

  # Show archives grouped by year.
  get map.path_to(:archive) do
    @posts = @site.find_archived.all_posts.limit(10).reverse
    @page.title, @page.keywords = @map.path_to_title(:archive), @tags
    show :archive
  end

  get map.path_to(:archive, "/") do
	  redirect @map.path_to(:archive), 301
  end

  # Show selected post in archive.
  get map.path_to(:archive, ":year/:month/:day/:name") do |year, month, day, name|
    @post = @site.find_archived.post(year, month, day, name)
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :post, :url => :archive
  end

  get map.path_to(:archive, ":year/:month/:day/:name/") do |year, month, day, name|
	  redirect @map.path_to(:archive, year, month, day, name), 301
  end

  # Show all archived posts by selected tag.
  get map.path_to(:archive, :tags, ":tag") do |tag|
    @tag   = @site.find_archived.tag(tag)
    @posts = @site.find_archived.all_posts_by_tag(tag)
    @page.title, @page.keywords = "#{@map.path_to_title(:tags)} - #{@tag.capitalize}", %(posts #{@tag}) unless @posts.empty?
    show :tag, :url => :archive
  end

  get map.path_to(:archive, :tags,":tag", "/") do |tag|
    redirect map.path_to(:archive, :tags, tag), 301
  end

  # Show all drafts.
  get map.path_to(:drafts) do
    @posts = @site.find_drafted.all_posts
    @page.title, @page.keywords = @map.path_to_title(:drafts), ["drafts"] + @tags
    show :posts, :url => :drafts
  end

  get map.path_to(:drafts, "/") do
    redirect @map.path_to(:drafts), 301
  end

  # Show selected drafted post.
  get map.path_to(:drafts, ":year/:month/:day/:name") do |year, month, day, name|
    @post = @site.find_drafted.post(year, month, day, name)
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :post, :url => :drafts
  end

  get map.path_to(:drafts, ":year/:month/:day/:name/") do |year, month, day, name|
	  redirect @map.path_to(:drafts, year, month, day, name), 301
  end

  # Show information site.
  get map.path_to(:about) do
    show :about
  end

  get map.path_to(:about, "/") do
	  redirect @map.path_to(:about), 301
  end

  # Search posts by title or match file name.
  get map.path_to(:search) do
    @posts   = @site.find.posts(*params.values)
    @archive = @site.find_archived.posts(*params.values)
    @page.title, @page.keywords = @map.path_to_title(:search), @tags
    show :search
  end

  def show(template, locals = {}, options = {})
    erb template, options, locals
  end
  private :show

end # class Application

end # module Postview

