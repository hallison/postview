$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")
require 'test/unit'
require 'lib/postview'

class TestRouter < Test::Unit::TestCase

  def setup
    @settings = Postview::Settings.new("#{Postview::PATH}/test/fixtures/settings.yml")
    @map      = @settings.build_mapping
  end

  def test_should_check_all_attributes
    assert_equal "/",        @map.root
    assert_equal "/posts",   @map.path_to(:posts)
    assert_equal "/tags",    @map.path_to(:tags)
    assert_equal "/archive", @map.path_to(:archive)
    assert_equal "/search",  @map.path_to(:search)
    assert_equal "/about",   @map.path_to(:about)
  end

  def test_should_check_attributes_for_new_root
    @map.root = "blog"

    assert_equal "/blog/", @map.root
    assert_equal "/blog/posts",   @map.path_to(:posts)
    assert_equal "/blog/tags",    @map.path_to(:tags)
    assert_equal "/blog/archive", @map.path_to(:archive)
    assert_equal "/blog/search",  @map.path_to(:search)
    assert_equal "/blog/about",   @map.path_to(:about)
  end

  def test_should_check_attributes_for_paths_with_params
    assert_equal "/posts/:year/:month/:day/:name", @map.path_to(:posts, ":year/:month/:day/:name")
  end

  def test_should_parse_path_to_title
    assert_equal "Tags", @map.path_to_title(:tags)
    assert_equal "Archive", @map.path_to_title(:archive)

    @map.root = "blog"

    assert_equal "Search", @map.path_to_title(:search)
    assert_equal "About", @map.path_to_title(:about)
  end

  def test_should_parse_nested_attributes
    @map.locations[:tags] = "taggeds"

    assert_equal "/archive/taggeds",      @map.path_to(:archive, :tags)
    assert_equal "/archive/taggeds/ruby", @map.path_to(:archive, :tags, "ruby")

    @map.root = "blog"

    assert_equal "/blog/archive/taggeds",      @map.path_to(:archive, :tags)
    assert_equal "/blog/archive/taggeds/ruby", @map.path_to(:archive, :tags, "ruby")
  end

end

