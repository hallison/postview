module Postview

class Application < Sinatra::Base

  configure do
    set :app_file, __FILE__
    set :root,     Postview::PATH
    set :static,   true

    set :site,          Site.load
    set :page,          { :title => site.about[:subtitle], :keywords => [] }
    set :posts_path,    site.paths[:posts]
    set :tags_path,     site.paths[:tags]
    set :archive_path,  site.paths[:archive]
    set :search_path,   site.paths[:search]
    set :about_path,    site.paths[:about]
  end

  configure :development do
    site.about[:url] = '/'
  end

  before do
    @site = options.site
    @page = options.page
  end

  helpers do
    attr_reader :site, :page, :posts, :tags, :archive, :post, :tag
  end

  # Show only the last 10 posts.
  get %{/} do
    @posts = @site.posts.reverse
    @page.replace(:title => @site.about[:subtitle], :keywords => [])
    erb :index
  end

  # Show all tags.
  get %{/#{tags_path}} do
    @tags  = @site.tags
    @page.replace(:title => @site.paths[:tags].capitalize, :keywords => @tags.keys.join(' '))
    erb :tags
  end

  # Show archives grouped by year.
  get %{/#{archive_path}} do
    "All archived posts will listed here by year ..."
  end

  # Search posts by title or match file name.
  get %{/#{search_path}} do
    @posts = @site.search_posts(*params.values)
    @page.replace(:title => @site.paths[:search].capitalize, :keywords => [])
    erb :search
  end

  # Show information site.
  get %{/#{about_path}} do
    "I'm running on Sinatra v" + Sinatra::VERSION
  end

  # Show selected post.
  get %r{/#{posts_path}/(\d{4})/(\d{2})/(\d{2})/([\w]+)} do |year, month, day, name|
    @post = @site.find_post(year, month, day, name)
    @page.replace(:title => @post[:title], :keywords => @post[:tags].keys.join(' '))
    erb :post, :locals => { :post => @post }
  end

  # Show all posts by selected tag.
  get %{/#{tags_path}/:tag} do |tag|
    @tag   = tag
    @posts = @site.find_all_posts_by_tag(@tag)
    @page.replace(:title => @tag.capitalize, :keywords => [ @tag ]) unless @site.posts.empty?
    erb :tag
  end

end # class Application

end # module Postview

