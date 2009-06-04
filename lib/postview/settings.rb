module Postview

class Settings

  attr_reader :about, :directories, :paths

  def initialize(file_name)
    YAML.load_file(file_name).symbolize_keys.instance_variables_set_to(self)
  end

  def file_names_for(directory, pattern = "**.*")
    Dir[File.join(directory_for(directory), pattern)]
  end

  def directory_for(name)
    return directories[name] if directories[name].match(%r{^/.*})
    File.join(PATH, directories[name])
  end

  def build_site
    Site.new(self)
  end

  def self.load
    new(SETTINGS)
  end

end # class Settings

end # module Postview
