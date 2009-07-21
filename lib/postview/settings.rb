module Postview

class Settings

  class FileError < Errno::ENOENT
     def self.message
       "#{Postview}: #{$!}"
     end
  end

  DEFAULTS = {
    :site => {
      :title    => "Postview",
      :subtitle => "Post your articles",
      :author   => "Hallison Batista",
      :email    => "email@example.com",
      :url      => "http://example.com/"
    },
    :directories => {
      :posts   => "#{ROOT}/posts",
      :archive => "#{ROOT}/posts/archive",
      :drafts  => "#{ROOT}/posts/drafts"
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

  attr_reader :site, :directories, :mapping

  def initialize(attributes = {})
    attributes.symbolize_keys.merge(DEFAULTS) do |key, value, default|
      value || default
    end.instance_variables_set_to(self)
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
    Postage::Finder.new(directory_for(directory))
  end

  def self.load
    begin
      load_file(SETTINGS)
    rescue FileError => error
      $stdout.puts <<-end_error.gsub(/[ ]{8}/,'')
        >> #{error}
        >> Please, create file #{ROOT}/config/settings.yml.
      end_error
      new(DEFAULTS)
    end
  end

  def self.load_file(file_name)
    raise FileError unless File.exist? file_name
    new(YAML.load_file(file_name))
  end

  def file_names_for(directory, pattern = "**.*")
    Dir[File.join(directory_for(directory), pattern)]
  end

  def directory_for(name)
    return directories[name] if directories[name].match(%r{^/.*})
    File.join(ROOT, directories[name])
  end

end # class Settings

end # module Postview
