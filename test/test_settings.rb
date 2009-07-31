$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'test/unit'
require 'lib/postview'

class TestSettings < Test::Unit::TestCase

  def setup
    @attributes = {
      :site => {
        :title     => "Postview",
        :subtitle  => "Post your articles",
        :author    => "Jack Ducklet",
        :email     => "jack.ducklet@example.com",
        :host      => "jackd.example.com",
        :directory => "path/to/site"
      },
      :directories => {
        :posts   => "test/fixtures/posts",
        :archive => "test/fixtures/posts/archive",
        :drafts  => "test/fixtures/posts/drafts"
      },
      :mapping => {
        :root    => nil,
        :posts   => "posts",
        :tags    => "tags",
        :archive => "archive",
        :drafts  => "drafts",
        :search  => "search",
        :about   => "about"
      }
    }
    @settings = Postview::Settings.load_file("#{Postview::ROOT}/test/fixtures/settings.yml")
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
    assert_not_nil @settings.build_site.find_archived
    assert_not_nil @settings.build_site.find_drafted
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

end

