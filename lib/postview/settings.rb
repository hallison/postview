module Postview

class Settings

  DEFAULTS = {
    :site => {
      :title     => "Postview",
      :subtitle  => "Post your articles",
      :author    => "Hallison Batista",
      :email     => "email@example.com",
      :host      => "example.com",
      :directory => "/var/www/example"
    },
    :directories => {
      :posts   => "posts",
      :archive => "posts/archive",
      :drafts  => "posts/drafts"
    },
    :mapping => {
      :root    => "",
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
    load_file(SETTINGS)
  end

  def self.load_file(file_name)
    begin
      new(YAML.load_file(file_name) || DEFAULTS)
    rescue Errno::ENOENT
      new(DEFAULTS)
    end
  end

  def self.build_default_file
    File.open(Postview::SETTINGS, "w+") do |file|
      file << Postview::Settings::DEFAULTS.to_yaml
    end unless File.exist? Postview::SETTINGS
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
