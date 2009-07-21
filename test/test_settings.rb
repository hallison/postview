$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'test/unit'
require 'lib/postview'

class TestSettings < Test::Unit::TestCase

  def setup
    @attributes = {
      :site => {
        :title    => "Postview",
        :subtitle => "Post your articles",
        :author   => "Jack Ducklet",
        :email    => "jack.ducklet@example.com",
        :url      => "http://jackd.example.com/"
      },
      :directories => {
        :posts   => "test/fixtures/posts",
        :archive => "test/fixtures/posts/archive",
        :drafts  => "test/fixtures/posts/drafts"
      },
      :mapping => {
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

  def test_should_rescue_exception_for_file_not_found_and_load_defaults
    assert_raise Postview::Settings::FileError do
      @settings = Postview::Settings.load_file("file/not/found.yml")
    end
  end

  def test_should_rescue_exception_and_load_defaults
    assert_raise Postview::Settings::FileError do
      settings = Postview::Settings.load_file("file/not/found.yml")
      Postview::Settings::DEFAULTS.each do |method, values|
        values.collect do |key, value|
          assert_equal value, @settings.send(method)[key]
        end
      end
    end
  end

end

