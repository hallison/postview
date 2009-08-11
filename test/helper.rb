require 'ruby-debug'

module Postview
  PATH = Pathname.new("test/fixtures/application").expand_path
  class Settings
    FILE = PATH.join("config/settings.yml").expand_path
  end
end

