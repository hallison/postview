module Postview

# Copyright (c) 2009 Hallison Batista
class Application < Sinatra::Base #:nodoc: all

  register Sinatra::Mapping

  configure do
    set :settings, Postview::Settings.load
    set :site,     settings.build_site
    set :page,     settings.build_page

    set :static, true

    set :root,   Postview::PATH
    set :public, Postview::PATH.join("public")
    set :views,  Postview::PATH.join("themes", site.theme)

    map :theme, "/"

    mapping settings.sections
  end

  before do
    @settings = options.settings
    @site     = options.site
    @page     = options.page
    @tags     = @site.find_all_tags
    @posts    = @site.find.all_posts.reverse
    @archive  = @site.find_archived.all_posts.reverse
  end

  helpers Postview::Helpers

  # Get theme resources
  # TOFIX: Check security and other problems
  get theme_path "/:resource/*.*" do |resource, file, ext|
    send_file options.views.join(resource, "#{file}.#{ext}")
  end

  # Show only the last 5 posts.
  get root_path do
    @posts = @site.find.all_posts.limit(5).reverse
    @page.title, @page.keywords = @site.subtitle, "posts"
    show :index, :posts_path => :posts, :tags_path => :tags
  end

  # Show all posts.
  get posts_path do
    @page.title, @page.keywords = title_path(:posts), @tags.join(' ')
    show :"posts/index", :posts_path => :posts, :tags_path => :tags
  end

  # Show selected post.
  get posts_path "/:year/:month/:day/:name" do |year, month, day, name|
    @post = @site.find.post(year, month, day, name)
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :"posts/show", :posts_path => :posts, :tags_path => :tags
  end

  # Show all tags.
  get tags_path do
    @page.title, @page.keywords = title_path(:tags), @tags.join(' ')
    show :"tags/index", :posts_path => :posts, :tags_path => :tags
  end

  # Show all posts by selected tag.
  get tags_path "/:tag" do |tag|
    @tag     = @site.find_tag(tag)
    @posts   = @site.find.all_posts_by_tag(tag)
    @archive = @site.find_archived.all_posts_by_tag(tag)
    @page.title, @page.keywords = "#{title_path(:tags)} - #{@tag.capitalize}", "posts #{@tag}" unless @posts.empty?
    show :"tags/show", :posts_path => :posts, :archive_path => :archive, :tags_path => :tags
  end

  # Show archives grouped by year.
  get archive_path do
    @posts = @site.find_archived.all_posts.reverse
    @page.title, @page.keywords = title_path(:archive), @tags.join(' ')
    show :"archive/index", :archive_path => :archive, :posts_path => :archive, :tags_path => :tags
  end

  # Show selected post in archive.
  get archive_path "/:year/:month/:day/:name" do |year, month, day, name|
    @post  = @site.find_archived.post(year, month, day, name)
    @posts = @site.find_archived.all_posts.reverse
    @tags  = @site.find_archived.all_tags
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :"archive/show", :posts_path => :archive, :tags_path => :tags
  end

  # Show all drafts.
  get drafts_path do
    @posts = @site.find_drafted.all_posts.reverse
    @tags  = @site.find_drafted.all_tags.sort
    @page.title, @page.keywords = title_path(:drafts), "drafts #{@tags.join(' ')}"
    show :"posts/index", :posts_path => :drafts, :tags_path => [:drafts, :tags]
  end

  # Show selected drafted post.
  get drafts_path "/:year/:month/:day/:name" do |year, month, day, name|
    @post  = @site.find_drafted.post(year, month, day, name)
    @posts = @site.find_drafted.all_posts.reverse
    @tags  = @site.find_drafted.all_tags.sort
    @page.title, @page.keywords = @post.title, @post.tags.join(' ')
    show :"posts/show", :posts_path => :drafts, :tags_path => [:drafts, :tags]
  end

  # Show information site.
  get about_path do
    show :about, :about_path => :about, :posts_path => :posts, :tags_path => :tags
  end

  # Search posts by title or match file name.
  get search_path do
    @posts   = @site.find.posts(*params.values)
    @archive = @site.find_archived.posts(*params.values)
    @page.title, @page.keywords = title_path(:search), @tags.join(' ')
    show :search, :posts_path => :posts, :tags_path => :tags, :archive_path => :archive, :search_path => :search
  end

  def show(template, locals = {}, options = {})
    erb template, options.update(:locals => locals)
  end
  private :show

end # class Application

end # module Postview

