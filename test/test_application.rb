$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'rack/test'

#set :environment, :test 
#
#configure :test do
#  set :settings, Settings.new("#{Postview::PATH}/test/fixtures/settings.yml")
#  set :site,     settings.build_site
#  set :route,    settings.build_router
#end

class TestApplication < Test::Unit::TestCase

  include Rack::Test::Methods

  attr_reader :settings, :site, :map, :page

  def setup
    @settings = Postview::Settings.new("#{Postview::PATH}/test/fixtures/settings.yml")
    @site     = @settings.build_site
    @map      = @settings.build_mapping
    @page     = OpenStruct.new(:title => @site.subtitle, :keywords => [])
  end

  def app
    @app = Postview::Application
    @app.set :settings, @settings
    @app.set :site,     @site
    @app.set :map,      @map
    @app.set :page,     @page
    @app
  end

  def test_should_return_ok_in_root_path
    get map.root do |response|
      assert response.ok?
    end

    get map.root.gsub(/\/$/, '') do |response|
      assert response.ok?
    end
  end

  def test_should_return_ok_in_posts_path
    get map.path_to(:posts) do |response|
      assert response.ok?
    end

    get map.path_to(:posts, "/") do
      follow_redirect!
      assert last_response.ok?
    end
  end

  def test_should_return_ok_in_posts_path_with_params
    get map.path_to(:posts, "2009/06/02/postview_blogware") do |response|
      assert response.ok?
      assert_equal "http://example.org/posts/2009/06/02/postview_blogware", last_request.url
    end

    get map.path_to(:posts, "2009/06/02/postview_blogware/") do
      follow_redirect!
      assert last_response.ok?
      assert_equal "http://example.org/posts/2009/06/02/postview_blogware", last_request.url
    end
  end

  def test_should_return_ok_in_tags_path
    get map.path_to(:tags) do |response|
      assert response.ok?
    end

    get map.path_to(:tags, "/") do
      follow_redirect!
      assert last_response.ok?
    end
  end

  def test_should_return_ok_in_tags_path_with_params
    get map.path_to(:tags, "ruby") do |response|
      assert response.ok?
      assert_equal "http://example.org/tags/ruby", last_request.url
    end

    get map.path_to(:tags, "ruby/") do
      follow_redirect!
      assert last_response.ok?
      assert_equal "http://example.org/tags/ruby", last_request.url
    end
  end

  def test_should_return_ok_in_archive_path
    get map.path_to(:archive) do |response|
      assert response.ok?
    end

    get map.path_to(:archive, "/") do
      follow_redirect!
      assert last_response.ok?
    end
  end

  def test_should_return_ok_in_archive_path_with_params
    get map.path_to(:archive, "2008/06/02/postview_blogware") do |response|
      assert response.ok?
      assert_equal "http://example.org/archive/2008/06/02/postview_blogware", last_request.url
    end

    get map.path_to(:archive, "2008/06/02/postview_blogware/") do
      follow_redirect!
      assert last_response.ok?
      assert_equal "http://example.org/archive/2008/06/02/postview_blogware", last_request.url
    end
  end

  def test_should_return_ok_in_archive_tagged_path_with_params
    get map.path_to(:archive, :tags, "ruby") do |response|
      assert response.ok?
      assert_equal "http://example.org/archive/tags/ruby", last_request.url
    end

    get map.path_to(:archive, :tags, "ruby/") do
      follow_redirect!
      assert last_response.ok?
      assert_equal "http://example.org/archive/tags/ruby", last_request.url
    end
  end

  def test_should_return_ok_in_drafts_path
    get map.path_to(:drafts) do |response|
      assert response.ok?
      assert_equal "http://example.org/drafts", last_request.url
    end

    get map.path_to(:drafts, "/") do
      follow_redirect!
      assert last_response.ok?
    end
  end

  def test_should_return_ok_in_drafts_path_with_params
    get map.path_to(:drafts, "2009/07/30/draft_postview_blogware") do |response|
      assert response.ok?
      assert_equal "http://example.org/drafts/2009/07/30/draft_postview_blogware", last_request.url
    end

    get map.path_to(:drafts, "2009/07/30/draft_postview_blogware/") do
      follow_redirect!
      assert last_response.ok?
      assert_equal "http://example.org/drafts/2009/07/30/draft_postview_blogware", last_request.url
    end
  end

  def test_should_return_ok_in_about_path
    get map.path_to(:about) do |response|
      assert response.ok?
    end

    get map.path_to(:about, "/") do
      follow_redirect!
      assert last_response.ok?
    end
  end

  def test_should_return_ok_in_search_path
    get map.path_to(:search), :anythink => "postview" do |response|
      assert response.ok?
      assert_equal "postview", last_request.params.values.to_s
      assert_equal "http://example.org/search?anythink=postview", last_request.url
    end
  end

end

