module Postview

# Copyright (c) 2009 Hallison Batista
class Site

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

  # Finder for posts
  attr_accessor :find

  # Finder for archived posts
  attr_accessor :find_archived

  # Finder for drafted posts
  attr_accessor :find_drafted

  def initialize(attributes = {})
    attributes.instance_variables_set_to(self)
  end

  def find_all_tags
    (find.all_tags + find_archived.all_tags).uniq.sort
  end

  def find_tag(tag)
    find.tag(tag) || find_archived.tag(tag)
  end

end # class Site

end #module Postview

