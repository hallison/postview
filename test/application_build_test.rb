$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'lib/postview'
require 'test/unit'
require 'rack/test'
require 'test/customizations'

class ApplicationBuildTest < Test::Unit::TestCase

  include Rack::Test::Methods

  class Postview::Application::Build
  private
    def build!
      erb "builded"
    end
  end

  def setup
    Postview::path = "test/fixtures/blog"
  end

  def app
    @app = Postview::Application::Build

    @app.set :root, "#{File.dirname(__FILE__)}/.."
    @app.set :environment, :test
    @app
  end

  should "build new blog using defaults" do

    post app.build_path, :password => "sekret" do |response|
      assert response.ok?
      assert_match "successfully", response.body
    end

  end

end

