$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'rack/test'
require 'test/customizations'

class ApplicationTest < Test::Unit::TestCase

  include Rack::Test::Methods

  def setup
    Postview::path = "test/fixtures/application"
  end

  def app
    @app = Postview::Application

    @app.set :root, "#{File.dirname(__FILE__)}/.."
    @app.set :environment, :test
    @app
  end

  def test_should_return_ok_for_theme_resources
    get "/images/favicon.ico" do |response|
      assert response.ok?
      assert_equal "http://example.org/images/favicon.ico", last_request.url
    end

    get "/javascripts/postview.js" do |response|
      assert response.ok?
      assert_equal "http://example.org/javascripts/postview.js", last_request.url
    end

    get "/stylesheets/postview.css" do |response|
      assert response.ok?
      assert_equal "http://example.org/stylesheets/postview.css", last_request.url
    end

    get "/images/banners/banner.jpg" do |response|
      assert response.ok?
      assert_equal "http://example.org/images/banners/banner.jpg", last_request.url
    end
  end

  def test_should_return_ok_in_root_path
    get app.root_path do |response|
      assert response.ok?
    end
  end

  def test_should_return_ok_in_posts_path
    get app.posts_path do |response|
      assert response.ok?
    end
  end

  def test_should_return_ok_in_posts_path_with_params
    get app.posts_path "/2009/06/02/fourth_article" do |response|
      assert response.ok?
      assert_equal "http://example.org/posts/2009/06/02/fourth_article/", last_request.url
    end
  end

  def test_should_return_ok_in_tags_path
    get app.tags_path do |response|
      assert response.ok?
      assert_equal "http://example.org/tags/", last_request.url
    end
  end

  def test_should_return_ok_in_tags_path_with_params
    get app.tags_path "t1" do |response|
      assert response.ok?
      assert_equal "http://example.org/tags/t1/", last_request.url
    end
  end

  def test_should_return_ok_in_archive_path
    get app.archive_path do |response|
      assert response.ok?
    end
  end

  def test_should_return_ok_in_archive_path_with_params
    get app.archive_path "2008/06/02/second_article" do |response|
      assert response.ok?
      assert_equal "http://example.org/archive/2008/06/02/second_article/", last_request.url
    end
  end

  def test_should_return_ok_in_drafts_path
    authorize("Jack Ducklet", "s3kr3t")
    get app.drafts_path do |response|
      assert response.ok?
      assert_equal "http://example.org/drafts/", last_request.url
    end
  end

  def test_should_return_ok_in_drafts_path_with_params
    authorize("Jack Ducklet", "s3kr3t")
    get app.drafts_path "2009/07/30/fifth_article" do |response|
      assert response.ok?
      assert_equal "http://example.org/drafts/2009/07/30/fifth_article/", last_request.url
    end
  end

  def test_should_return_ok_in_about_path
    get app.about_path do |response|
      assert response.ok?
    end
  end

  def test_should_return_ok_in_search_path
    get app.search_path, :anythink => "first" do |response|
      assert response.ok?
      assert_equal "first", last_request.params.values.to_s
      assert_equal "http://example.org/search/?anythink=first", last_request.url
    end
  end

  should "return ok in authorize path" do
    authorize("Jack Ducklet", "s3kr3t")
    get app.manager_path do |response|
      assert response.ok?
      assert_equal "http://example.org/manager/", last_request.url
    end
  end

  should "load shared themes" do
    site_path = Pathname.new("test/fixtures/site").expand_path
    Postview::path = site_path.join("blog")
    assert_equal site_path.join("themes/mytheme"), app.theme
  end

end

