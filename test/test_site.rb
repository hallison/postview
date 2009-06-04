$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")
require 'test/unit'
require 'lib/postview'

class TestSitePosts < Test::Unit::TestCase

  def setup
    @settings = Postview::Settings.new("#{Postview::PATH}/test/fixtures/settings.yml")
    @site = @settings.build_site
  end

  def test_check_attributes
    assert_equal 'Postview', @site.title
    assert_equal 'Post your articles.', @site.subtitle
    assert_equal 'Jack Ducklet', @site.author
    assert_equal 'jack.ducklet@example.com', @site.email
    assert_equal 'http://jackd.example.com/', @site.url
  end

  def test_should_find_all_posts
    posts = @site.find.all_posts
    assert_not_nil posts
    assert 4, posts.size
    posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file
    end
  end

  def test_should_find_all_tags
    tags = @site.find.all_tags
    assert_not_nil tags
    assert_equal 3, tags.size
  end

  def test_should_find_all_archived
    posts = @site.find_archived.all_posts
    assert_not_nil posts
    assert 2, posts.size
    posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file
    end
  end

  def test_should_find_post
    post = @site.find.post(*%w(2009 06 04 postview))
    assert_not_nil post
  end

  def test_should_search_posts
    posts = @site.find.posts('blogware')
    assert 2, posts.size
  end

end

