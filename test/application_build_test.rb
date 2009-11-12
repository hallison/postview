$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'rack/test'
require 'test/customizations'

class ApplicationBuildTest < Test::Unit::TestCase

  include Rack::Test::Methods

  def setup
    Postview::path = "test/fixtures/blog"
  end

  def app
    @app = Postview::Application::Setup

    @app.set :root, "#{File.dirname(__FILE__)}/.."
    @app.set :environment, :test
    @app
  end

  should "return all settings and all posts in index" do

    get app.root_path do |response|
      assert response.ok?
    end

  end

end

