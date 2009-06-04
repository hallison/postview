$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'test/unit'
require 'lib/postview'

class TestFinder < Test::Unit::TestCase

  def setup
    @settings = Postview::Settings.new("#{Postview::PATH}/test/fixtures/settings.yml")
    @find     = Postview::Finder.new(@settings.file_names_for(:posts))
  end

  def test_should_find_post
    post = @find.post(*%w(2009 05 29 postview*))
    assert_not_nil post
    assert Date.new(2009,5,29), post.publish_date
  end

  def test_should_load_all_posts
    posts = @find.all_posts
    assert 4, posts.size
  end

  def test_should_load_all_tags
    tags = @find.all_post_tags
    assert 3, tags.size
  end

  def test_should_load_all_archived
    posts = @find.all_archived
    assert_not_nil posts
    assert 2, posts.size
  end

end

