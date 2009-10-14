$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'rack/test'
require 'test/customizations'

class SettingsTest < Test::Unit::TestCase

  def setup
    @attributes = {
      :site => {
        :title     => "Postview",
        :subtitle  => "Post your articles",
        :author    => "Jack Ducklet",
        :email     => "jack.ducklet@example.com",
        :domain    => "jackd.example.com",
        :directory => "path/to/site",
        :theme     => "mytheme"
      },
      :directories => {
        :posts   => "posts",
        :archive => "posts/archive",
        :drafts  => "posts/drafts",
        :themes  => "themes"
      },
      :sections => {
        :root    => "/",
        :posts   => "posts",
        :tags    => "tags",
        :archive => "archive",
        :drafts  => "drafts",
        :search  => "search",
        :about   => "about"
      }
    }
    Postview::path = "test/fixtures/application"
    @settings = Postview::Settings.load
  end

  def test_should_check_settings
    @attributes.each do |method, values|
      values.collect do |key, value|
        assert_equal value, @settings.send(method)[key]
      end
    end
  end

  def test_should_build_site
    assert_not_nil @settings.build_site
    assert_not_nil @settings.build_site.find
    assert_not_nil @settings.build_site.find_in_archive
    assert_not_nil @settings.build_site.find_in_drafts
  end

  def test_should_rescue_exception_and_load_defaults
    settings = Postview::Settings.load_file("file/not/found.yml")
    @attributes.each do |method, values|
      values.collect do |key, value|
        assert_equal value, @settings.send(method)[key]
      end
    end
  end

  def test_should_rescue_exception_for_empty_file_and_load_defaults
    settings = Postview::Settings.load_file("#{Postview::ROOT}/test/fixtures/empty.yml")
    @attributes.each do |method, values|
      values.collect do |key, value|
        assert_not_nil settings.send(method)[key]
      end
    end
  end

  should "load theme from shared directory" do
    site_path = Pathname.new("test/fixtures/site").expand_path
    Postview::path = site_path.join("blog")
    assert_equal site_path.join("themes"), Postview::Settings.load.path_to(:themes)
  end

end

