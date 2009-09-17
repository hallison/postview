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
    @page = options.page
    @settings ||= options.settings
    @site ||= options.site
    @all_tags ||= @site.find_all_tags
    @all_posts ||= @site.find.all_posts.reverse
    @all_archived_posts ||= @site.find_in_archive.all_posts.reverse
    @all_drafted_posts ||= @site.find_in_drafts.all_posts.reverse
    @current_post ||= @all_posts.last
  end

  helpers Postview::Helpers

  # Get theme resources
  # TOFIX: Check security and other problems
  get theme_path "/:resource/*.*" do |resource, file, ext|
    send_file options.views.join(resource, "#{file}.#{ext}")
  end

  # Show all information for site.
  get root_path do
    @page.title, @page.keywords = @site.subtitle, "posts"
    show :index
  end

  # Show all posts.
  get posts_path do
    @page.title, @page.keywords = title_path(:posts), @all_tags.join(' ')
    show :"posts/index"
  end

  # Show selected post.
  get posts_path "/:year/:month/:day/:name" do |year, month, day, name|
    @current_post = @site.find.post(year, month, day, name)
    @page.title, @page.keywords = @current_post.title, @current_post.tags.join(' ')
    show :"posts/show"
  end

  # Show all tags.
  get tags_path do
    @page.title, @page.keywords = title_path(:tags), @all_tags.join(' ')
    show :"tags/index"
  end

  # Show all posts by selected tag.
  get tags_path "/:tag" do |tag|
    @current_tag = @site.find_tag(tag)
    @posts_found, @archived_posts_found = @site.find_all_posts_tagged_with(tag)
    @page.title, @page.keywords = "#{title_path(:tags)} - #{@current_tag.capitalize}", "posts #{@current_tag}"
    show :"tags/show"
  end

  # Show archives grouped by year.
  get archive_path do
    @page.title, @page.keywords = title_path(:archive), @all_tags.join(' ')
    show :"archive/index"
  end

  # Show selected post in archive.
  get archive_path "/:year/:month/:day/:name" do |year, month, day, name|
    @current_post = @site.find_in_archive.post(year, month, day, name)
    @page.title, @page.keywords = @current_post.title, @current_post.tags.join(' ')
    show :"archive/show"
  end

  # Show all drafts.
  get drafts_path do
    @all_tags = @site.find_in_drafts.all_tags.sort
    @page.title, @page.keywords = title_path(:drafts), "drafts #{@all_tags.join(' ')}"
    show :"drafts/index"
  end

  # Show selected drafted post.
  get drafts_path "/:year/:month/:day/:name" do |year, month, day, name|
    @current_post = @site.find_in_drafts.post(year, month, day, name)
    @all_tags = @site.find_in_drafts.all_tags.sort
    @page.title, @page.keywords = @current_post.title, @current_post.tags.join(' ')
    show :"drafts/show"
  end

  # Show information site.
  get about_path do
    show :about
  end

  # Search posts by title or match file name.
  get search_path do
    @posts_found, @archived_posts_found = @site.search_posts(*params.values)
    @page.title, @page.keywords = title_path(:search), @all_tags.join(' ')
    show :search
  end

  def show(template, locals = {}, options = {})
    erb template, options.update(:locals => locals)
  end
  private :show

end # class Application

end # module Postview

