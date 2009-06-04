$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'test/unit'
require 'lib/postview'

class TestSettings < Test::Unit::TestCase

  def setup
    @attributes = {
      :about => {
        :title    => "Postview",
        :subtitle => "Post your articles.",
        :author   => "Jack Ducklet",
        :email    => "jack.ducklet@example.com",
        :url      => "http://jackd.example.com/"
      },
      :directories => {
        :posts   => "test/fixtures/posts",
        :archive => "test/fixtures/posts/archive",
        :drafts  => "test/fixtures/posts/drafts"
      },
      :paths => {
        :posts   => "posts",
        :tags    => "tags",
        :archive => "archive",
        :search  => "search",
        :about   => "about"
      }
    }
    @settings = Postview::Settings.new("#{Postview::PATH}/test/fixtures/settings.yml")
  end

  def test_should_check_settings
    @attributes.each do |method, values|
      values.collect do |key, value|
        assert_equal value, @settings.send(method)[key]
      end
    end
  end

  def test_should_build_site
    site = @settings.build_site
    assert_not_nil site
  end
end

