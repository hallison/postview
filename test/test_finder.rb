$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'test/unit'
require 'lib/postview'

class TestFinder < Test::Unit::TestCase

  def setup
    @settings      = Postview::Settings.new("#{Postview::PATH}/test/fixtures/settings.yml")
    @find_posted   = @settings.build_finder_for(:posts)
    @find_archived = @settings.build_finder_for(:archive)
  end

  def test_should_find_post_archived_post_and_drafted_post
    post     = @find_posted.post(*%w(2009 05 29 postview*))
    archived = @find_archived.post(*%w(2008 05 29 postview*))
    assert Date.new(2009,5,29), post.publish_date
    assert Date.new(2008,5,29), archived.publish_date
  end

  def test_should_load_all_posts
    assert_equal 2, @find_posted.all_posts.size
  end

  def test_should_load_all_tags
    assert_equal 2, @find_posted.all_post_tags.size
  end

  def test_should_load_all_archived
    assert_equal 2, @find_archived.all_posts.size
  end

end

