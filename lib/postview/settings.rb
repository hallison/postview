module Postview

# Copyright (c) 2009 Hallison Batista
class Settings

  DEFAULTS = {
    :site => {
      :title     => "Postview",
      :subtitle  => "Post your articles",
      :author    => "Hallison Batista",
      :email     => "email@example.com",
      :domain    => "example.com",
      :directory => "/var/www/example",
      :theme     => "default"
    },
    :directories => {
      :posts   => "posts",
      :archive => "posts/archive",
      :drafts  => "posts/drafts"
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
  FILE_NAME = "settings.yml"
  FILE_DIR  = "config"
  FILE      = Postview::PATH.join(FILE_DIR, FILE_NAME)

  attr_reader :site, :theme, :directories, :sections

  def initialize(attributes = {})
    attributes.symbolize_keys.merge(DEFAULTS) do |key, value, default|
      value || default
    end.instance_variables_set_to(self)
  end

  def build_site
    build_all_finders_for(Site.new(site))
  end

  def build_page
    OpenStruct.new(:title => "", :keywords => [])
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
    load_file(FILE)
  end

  def self.load_file(file_name)
    begin
      new(YAML.load_file(file_name) || DEFAULTS)
    rescue Errno::ENOENT
      new(DEFAULTS)
    end
  end

  def self.load_file_from(path)
    file = Pathname.new(path).join(FILE_DIR, FILE_NAME)
    new(YAML.load_file(file))
  end

  def self.build_default_file
    FILE.open "w+" do |file|
      file << DEFAULTS.to_yaml
    end unless FILE.exist?
  end

  def file
    FILE
  end

  def file_names_for(directory, pattern = "**.*")
    directory_for(directory, pattern)
  end

  def directory_for(name, *paths)
    return Pathname.new(directories[name], *paths) if directories[name].match(%r{^/.*})
    PATH.join(directories[name], *paths)
  end

  def to_hash
    DEFAULTS.keys.inject({}) do |hash, method|
      hash[method] = send(method)
      hash
    end
  end

end # class Settings

end # module Postview
