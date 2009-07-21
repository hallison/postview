$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")
require 'test/unit'
require 'lib/postview'

class TestSite < Test::Unit::TestCase

  def setup
    @site = Postview::Settings.load_file("#{Postview::ROOT}/test/fixtures/settings.yml").build_site
  end

  def test_check_attributes
    assert_equal 'Postview', @site.title
    assert_equal 'Post your articles', @site.subtitle
    assert_equal 'Jack Ducklet', @site.author
    assert_equal 'jack.ducklet@example.com', @site.email
    assert_equal 'http://jackd.example.com/', @site.url
  end

  def test_should_find_all_posts
    posts = @site.find.all_posts
    assert_not_nil posts
    assert_equal 2, posts.size
    posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file
    end
  end

  def test_should_find_all_tags
    tags = @site.find.all_tags
    assert_not_nil tags
    assert_equal 2, tags.size
  end

  def test_should_find_all_archived
    assert 2, @site.find_archived.all_posts.size
    @site.find_archived.all_posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file
    end
  end

  def test_should_find_all_drafts
    assert 1, @site.find_drafted.all_posts.size
    @site.find_drafted.all_posts.collect do |draft|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, draft.file
    end
  end

  def test_should_find_post
    assert_not_nil @site.find.post(*%w(2009 06 02 postview))
  end

  def test_should_search_posts
    assert 2, @site.find.posts('postview').size
  end

end

