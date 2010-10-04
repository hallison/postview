require 'test/unit'

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/customizations'

class ConfigurationTest < Test::Unit::TestCase

  PATH = Pathname.new("#{File.dirname(__FILE__)}/fixtures")

  def setup
    #:path => PATH.join("blog"),
    @options = {
      :directories => {
        :posts   => "articles",
        :drafts  => "articles/drafts",
        :themes  => "share/themes"
      },
      :site => {
        :title     => "Postview",
        :subtitle  => "Post your articles",
        :author    => "Jack Ducklet",
        :email     => "jack.ducklet@example.com",
        :domain    => "jackd.example.com",
        :directory => "path/to/site",
        :theme     => "mytheme"
      },
      :sections => {
        :root    => "/",
        :posts   => "/posts",
        :tags    => "/tags",
        :archive => "/archive",
        :drafts  => "/drafts",
        :search  => "/search",
        :about   => "/about"
      }
    }

    @config = Postview::Configuration.load @options
  end

  should "check configuration" do
    @options.each do |method, values|
      values.collect do |key, value|
        assert_equal(value, @config.send(method)[key])
      end
    end
  end

  should "create new configuration" do
    Postview::Configuration.new do |config|
      config.directories do |dir|
        dir.posts  = "texts"
        dir.drafts = "texts/drafts"
        dir.themes = "themes/person"
      end

      assert_equal Pathname.new("texts").expand_path,         config.directory_for.posts
      assert_equal Pathname.new("texts/drafts").expand_path,  config.directory_for.drafts
      assert_equal Pathname.new("themes/person").expand_path, config.directory_for.themes

      config.site do |blog|
        blog.title     = "Test title"
        blog.subtitle  = "Test subtitle"
        blog.author    = "Tester"
        blog.email     = "tester@domain.com"
        blog.domain    = "domain.com"
        blog.directory = "test/dir/to/blog"
        blog.theme     = "test"
        blog.token     = "c40fdf9855a492b471b86f91ef4ed2d06c021f7a6cf865a618aba0bdb0e5f8cc"
      end

      assert_equal "Test title",        config.site.title
      assert_equal "Test subtitle",     config.site.subtitle
      assert_equal "Tester",            config.site.author
      assert_equal "tester@domain.com", config.site.email
      assert_equal "domain.com",        config.site.domain
      assert_equal "test/dir/to/blog",  config.site.directory
      assert_equal "test",              config.site.theme
      assert_equal "c40fdf9855a492b471b86f91ef4ed2d06c021f7a6cf865a618aba0bdb0e5f8cc",
                    config.site.token

      config.sections do |map|
        map.root    = "blog"
        map.posts   = "artigos"
        map.drafts  = "artigos/rascunhos"
        map.archive = "artigos/arquivo"
        map.search  = "artigos/pesquisa"
      end

      assert_equal "/blog",                   config.url_for.root
      assert_equal "/blog/artigos",           config.url_for.posts
      assert_equal "/blog/artigos/rascunhos", config.url_for.drafts
      assert_equal "/blog/artigos/arquivo",   config.url_for.archive
      assert_equal "/blog/artigos/pesquisa",  config.url_for.search
    end
  end

  should "raise exception for empty configuration file" do
    assert_raise Postview::Configuration::EmptyError do
      config = Postview::Configuration.load_file(PATH.join("empty.yml"))
    end
  end

  #should "load configuration file" do
  #  config = Postview::Configuration.load_file(PATH.join("empty.yml"))
  #  @options.each do |method, values|
  #    values.collect do |key, value|
  #      assert_equal(value, config.send(method)[key])
  #    end
  #  end
  #end

#  should "build site" do
#    assert_not_nil @settings.build_site
#    assert_not_nil @settings.build_site.find
#    assert_not_nil @settings.build_site.find_in_archive
#    assert_not_nil @settings.build_site.find_in_drafts
#  end
#
#  should "rescue exception and load defaults" do
#    settings = Postview::Settings.load_file("file/not/found.yml")
#    @attributes.each do |method, values|
#      values.collect do |key, value|
#        assert_equal value, @settings.send(method)[key]
#      end
#    end
#  end
#
#  should "rescue exception for empty file, incomplete or null values and load defaults" do
#    settings = Postview::Settings.load_file("#{Postview::ROOT}/test/fixtures/empty.yml")
#    @attributes.each do |method, values|
#      values.collect do |key, value|
#        assert_not_nil settings.send(method)[key]
#      end
#    end
#    settings = Postview::Settings.load_file("#{Postview::ROOT}/test/fixtures/incomplete.yml")
#    @attributes.each do |method, values|
#      values.collect do |key, value|
#        assert_not_nil settings.send(method)[key]
#      end
#    end
#    settings = Postview::Settings.new(:site => nil)
#    @attributes.each do |method, values|
#      values.collect do |key, value|
#        assert_not_nil settings.send(method)[key]
#      end
#    end
#  end
#
#  should "load theme from shared directory" do
#    site_path = Pathname.new("test/fixtures/site").expand_path
#    Postview::path = site_path.join("blog")
#    assert_equal site_path.join("themes"), Postview::Settings.load.path_to(:themes)
#  end
#
end

