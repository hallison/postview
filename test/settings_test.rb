$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'test/helper'

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
        :theme     => "gemstone"
      },
      :directories => {
        :posts   => "posts",
        :archive => "posts/archive",
        :drafts  => "posts/drafts"
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

