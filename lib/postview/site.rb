# Copyright (c) 2009 Hallison Batista
class Postview::Site

  # Site title.
  attr_accessor :title

  # Subtitle
  attr_accessor :subtitle

  # Author site
  attr_accessor :author

  # Email to contact author
  attr_accessor :email

  # Domain for host site
  attr_accessor :domain

  # Remote directory for site
  attr_accessor :directory

  # Theme directory name.
  attr_accessor :theme

  # Token pass.
  attr_accessor :token

  # Finder for posts
  attr_accessor :find

  # Finder for archived posts
  attr_accessor :find_in_archive

  # Finder for drafted posts
  attr_accessor :find_in_drafts

  # Initialize site with attributes passed by arguments.
  def initialize(attributes = {})
    attributes.instance_variables_set_to(self)
  end

  # Find all tags from all posts and archived posts.
  def find_all_tags
    (find.all_tags + find_in_archive.all_tags).uniq.sort
  end

  # Find a specific tag from posts and archived posts.
  def find_tag(tag)
    find.tag(tag) || find_in_archive.tag(tag)
  end

  # Find all posts tagged with a specific tag.
  def find_all_posts_tagged_with(tag)
    [ find.all_posts_by_tag(tag), find_in_archive.all_posts_by_tag(tag) ]
  end

  # Find posts using any string values.
  # Returns two lists: posts and archived posts.
  def search_posts(*values)
    [ find.posts(*values), find_in_archive.posts(*values) ]
  end

  # Check authentication for user.
  def authenticate?(username, password)
    @token == self.class.tokenize(username, password, domain)
  end

  # Generate digest token.
  def self.tokenize(username, password, domain)
    require 'digest'
    Digest::SHA256.hexdigest("$#{username}?#{password}@#{domain}")
  end

end # class Postview::Site

