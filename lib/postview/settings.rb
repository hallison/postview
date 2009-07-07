module Postview

class Settings

  class FileError < Errno::ENOENT
     def self.message
       "#{Postview}: #{$!}"
     end
  end

  attr_reader :site, :directories, :mapping

  def initialize(file_name)
    raise FileError unless File.exist? file_name
    YAML.load_file(file_name).symbolize_keys.instance_variables_set_to(self)
  end

  def build_site
    build_all_finders_for(Site.new(site))
  end

  def build_all_finders_for(site)
    site.find          = build_finder_for(:posts)
    site.find_archived = build_finder_for(:archive)
    site.find_drafted  = build_finder_for(:drafts)
    site
  end

  def build_finder_for(directory)
    Finder.new(file_names_for(directory))
  end

  def build_mapping
    Mapping.new(mapping)
  end

  def self.load
    new(SETTINGS)
  end

private

  def file_names_for(directory, pattern = "**.*")
    Dir[File.join(directory_for(directory), pattern)]
  end

  def directory_for(name)
    return directories[name] if directories[name].match(%r{^/.*})
    File.join(PATH, directories[name])
  end

end # class Settings

end # module Postview
