$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'test/helper'
require 'test/extensions'

class TestSite < Test::Unit::TestCase

  def setup
    @site = Postview::Settings.load.build_site
  end

  should "check all attributes" do
    assert_equal 'Postview', @site.title
    assert_equal 'Post your articles', @site.subtitle
    assert_equal 'Jack Ducklet', @site.author
    assert_equal 'jack.ducklet@example.com', @site.email
    assert_equal 'jackd.example.com', @site.domain
    assert_equal 'path/to/site', @site.directory
    assert_equal 'gemstone', @site.theme
  end

  should "find all posts" do
    posts = @site.find.all_posts
    assert_not_nil posts
    assert_equal 2, posts.size
    posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file.to_s
    end
  end

  should "find all tags" do
    tags = @site.find.all_tags
    assert_not_nil tags
    assert_equal 4, tags.size
  end

  should "find all archived posts" do
    assert 2, @site.find_in_archive.all_posts.size
    @site.find_in_archive.all_posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file.to_s
    end
  end

  should "find all drafts" do
    assert 1, @site.find_in_drafts.all_posts.size
    @site.find_in_drafts.all_posts.collect do |draft|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, draft.file.to_s
    end
  end

  should "find one post" do
    assert_not_nil @site.find.post(*%w(2009 06 02 fourth))
  end

  should "search posts" do
    # TOFIX: The finder will be returns 2 posts.
    assert 4, @site.find.posts('first third').size
  end

end

