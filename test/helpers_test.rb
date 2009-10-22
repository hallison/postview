$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'rack/test'
require 'test/customizations'

class HelpersTest < Test::Unit::TestCase

  include Rack::Test::Methods
  include Postview::Helpers

  def app
    @app = Postview::Application::Blog

    @app.set :root, "#{File.dirname(__FILE__)}/.."
    @app.set :environment, :test

    @app
  end

  def setup
    Postview::path = "test/fixtures/blog"
    # for helpers
    @settings = app.settings
    @site = app.site
    @page = app.page
    @all_tags = @site.find_all_tags
    @all_posts = @site.find.all_posts
    @all_archived_posts = @site.find_in_archive.all_posts
    @all_drafted_posts = @site.find_in_drafts.all_tags
    @current_post = @all_posts.last
  end

  should "check latest posts" do
    get app.root_path do |response|
      assert response.ok?
      assert_equal 2, latest_posts.size
    end
  end

  should "check current post" do
    get app.root_path do |response|
      assert response.ok?
      assert_equal "2009/06/02/fourth_article", current_post.to_s
    end
  end

  should "check related posts and related tags" do
    get app.posts_path "/2009/05/29/third_article" do |response|
      assert response.ok?
      assert_equal 1, related_posts_in(:posts).size
      assert_equal 4, all_related_tags.size
    end

    get app.archive_path "/2008/06/02/second_article" do |response|
      assert response.ok?
      assert_equal 1, related_posts_in(:posts).size
    end
  end

  should "check only four tags" do
    get app.tags_path do |response|
      assert response.ok?
      assert_equal 4, all_tags.size
    end
  end

end

