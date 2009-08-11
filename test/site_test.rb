$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'test/helper'
require 'test/extensions'

class TestSite < Test::Unit::TestCase

  def setup
    @site = Postview::Settings.load.build_site
  end

  must "check all attributes" do
    assert_equal 'Postview', @site.title
    assert_equal 'Post your articles', @site.subtitle
    assert_equal 'Jack Ducklet', @site.author
    assert_equal 'jack.ducklet@example.com', @site.email
    assert_equal 'jackd.example.com', @site.domain
    assert_equal 'path/to/site', @site.directory
    assert_equal 'gemstone', @site.theme
  end

  must "find all posts" do
    posts = @site.find.all_posts
    assert_not_nil posts
    assert_equal 2, posts.size
    posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file.to_s
    end
  end

  must "find all tags" do
    tags = @site.find.all_tags
    assert_not_nil tags
    assert_equal 2, tags.size
  end

  must "find all archived posts" do
    assert 2, @site.find_archived.all_posts.size
    @site.find_archived.all_posts.collect do |post|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, post.file.to_s
    end
  end

  must "find all drafts" do
    assert 1, @site.find_drafted.all_posts.size
    @site.find_drafted.all_posts.collect do |draft|
      assert_match %r{\d{4}\d{4}-(\.*)\.*}, draft.file.to_s
    end
  end

  must "find one post" do
    assert_not_nil @site.find.post(*%w(2009 06 02 postview))
  end

  must "search posts" do
    assert 2, @site.find.posts('postview').size
  end

end

