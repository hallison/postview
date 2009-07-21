module Postview

class Application < Sinatra::Base

  register Sinatra::Mapping

  configure do
    set :app_file, __FILE__
    set :root,     ROOT
    set :static,   true

    set :settings, Settings.load
    set :site,     settings.build_site
    set :page,     OpenStruct.new(:title => site.subtitle, :keywords => [])

    mapping settings.mapping
  end

  configure :development do
    site.url = '/'
    map :root, site.url
  end

  before do
    @settings = options.settings
    @site     = options.site
    @page     = options.page
    @tags     = @site.find.all_tags.sort
    @posts    = @site.find.all_posts.reverse
  end

  helpers do
    attr_reader :site, :page, :posts, :tags, :archive, :post, :tag, :map
  end

  helpers Sinatra::MappingHelpers

  # Show only the last 5 posts.
  get root_path do
    @posts = @site.find.all_posts.limit(5).reverse
    @page.title, @page.keywords = @site.subtitle, %w(posts)
    show :posts, :posts_path => :posts, :tags_path => :tags
  end

  get root_path.gsub(/\/$/,'') do
	  redirect path_to(:root), 301
  end

  # Show all posts.
  get posts_path do
    @page.title, @page.keywords = title_path(:posts), @tags
    show :posts, :posts_path => :posts, :tags_path => :tags
  end

  get posts_path "/" do
    redirect path_to(:posts), 301
  end

  # Show selected post.
  get posts_path "/:year/:month/:day/:name" do |year, month, day, name|
    @post = @site.find.post(year, month, day, name)
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :post, :posts_path => :posts, :tags_path => :tags
  end

  get posts_path "/:year/:month/:day/:name/" do |year, month, day, name|
	  redirect path_to(:posts, year, month, day, name), 301
  end

  # Show all tags.
  get tags_path do
    @page.title, @page.keywords = title_path(:tags), @tags
    show :tags, :posts_path => :posts, :tags_path => :tags
  end

  get tags_path "/" do
	  redirect path_to(:tags), 301
  end

  # Show all posts by selected tag.
  get tags_path "/:tag" do |tag|
    @tag   = @site.find.tag(tag)
    @posts = @site.find.all_posts_by_tag(tag)
    @page.title, @page.keywords = "#{title_path(:tags)} - #{@tag.capitalize}", %(posts #{@tag}) unless @posts.empty?
    show :tag, :posts_path => :posts, :tags_path => :tags
  end

  get tags_path "/:tag/" do |tag|
    redirect path_to(:tags, tag), 301
  end

  # Show archives grouped by year.
  get archive_path do
    @posts = @site.find_archived.all_posts.reverse
    @tags  = @site.find_archived.all_tags
    @page.title, @page.keywords = title_path(:archive), @tags
    show :archive, :archive_path => :archive, :tags_path => [:archive,:tags]
  end

  get archive_path "/" do
	  redirect path_to(:archive), 301
  end

  # Show selected post in archive.
  get archive_path "/:year/:month/:day/:name" do |year, month, day, name|
    @post  = @site.find_archived.post(year, month, day, name)
    @posts = @site.find_archived.all_posts.reverse
    @tags  = @site.find_archived.all_tags
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :post, :posts_path => :archive, :tags_path => [:archive, :tags]
  end

  get archive_path "/:year/:month/:day/:name/" do |year, month, day, name|
	  redirect path_to(:archive, year, month, day, name), 301
  end

  # Show all archived posts by selected tag.
  get archive_path :tags, ":tag" do |tag|
    @tag   = @site.find_archived.tag(tag)
    @posts = @site.find_archived.all_posts_by_tag(tag).reverse
    @page.title, @page.keywords = "#{title_path(:tags)} - #{@tag.capitalize}", %(posts #{@tag}) unless @posts.empty?
    show :tag, :posts_path => :posts, :tags_path => [:archive, :tags]
  end

  get archive_path :tags, ":tag/" do |tag|
    redirect path_to(:archive, :tags, tag), 301
  end

  # Show all drafts.
  get drafts_path do
    @posts = @site.find_drafted.all_posts
    @tags  = @site.find_drafted.all_tags
    @page.title, @page.keywords = title_path(:drafts), ["drafts"] + @tags
    show :posts, :posts_path => :drafts, :tags_path => [:drafts, :tags]
  end

  get drafts_path "/" do
    redirect path_to(:drafts), 301
  end

  # Show selected drafted post.
  get drafts_path "/:year/:month/:day/:name" do |year, month, day, name|
    @post  = @site.find_drafted.post(year, month, day, name)
    @posts = @site.find_drafted.all_posts
    @tags  = @site.find_drafted.all_tags
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :posts, :posts_path => :drafts, :tags_path => [:drafts, :tags]
  end

  get drafts_path "/:year/:month/:day/:name/" do |year, month, day, name|
	  redirect path_to(:drafts, year, month, day, name), 301
  end

  # Show all drafted posts by selected tag.
  get drafts_path :tags, ":tag" do |tag|
    @tag   = @site.find_drafted.tag(tag)
    @posts = @site.find_drafted.all_posts_by_tag(tag).reverse
    @tags  = @site.find_drafted.all_tags
    @page.title, @page.keywords = "#{title_path(:tags)} - #{@tag.capitalize}", %(posts #{@tag}) unless @posts.empty?
    show :posts, :posts_path => :drafts, :tags_path => [:drafts, :tags]
  end

  get drafts_path :tags, ":tag/" do |tag|
    redirect path_to(:archive, :tags, tag), 301
  end

  # Show information site.
  get about_path do
    show :about, :about_path => :about
  end

  get about_path "/" do
	  redirect path_to(:about), 301
  end

  # Search posts by title or match file name.
  get search_path do
    @posts   = @site.find.posts(*params.values)
    @archive = @site.find_archived.posts(*params.values)
    @page.title, @page.keywords = title_path(:search), @tags
    show :search, :posts_path => :posts, :tags_path => :tags, :archive_path => :archive, :search_path => :search
  end

  def show(template, locals = {}, options = {})
    erb template, options, locals
  end
  private :show

end # class Application

end # module Postview

