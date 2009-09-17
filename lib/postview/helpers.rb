module Postview

# Copyright (c) 2009 Hallison Batista
module Helpers

  # Site information.
  attr_reader :site

  # Current page.
  attr_reader :page

  # Current post.
  attr_reader :current_post

  # Current tag.
  attr_reader :current_tag

  # All tags used in posts and archived posts.
  attr_reader :all_tags

  # All posts
  attr_reader :all_posts

  # All archived posts.
  attr_reader :all_archived_posts

  # All posts found by search.
  attr_reader :posts_found

  # All archived posts found by search.
  attr_reader :archived_posts_found

  # Returns latest posts.
  def latest_posts(limit = 5)
    @all_posts.limit(limit) || []
  end

  # Returns all posts related to any post.
  def related_posts_in(folder = :posts)
    posts = case folder
              when :posts
                all_posts
              when :archive
                all_archived_posts
              when :drafts
                all_drafted_posts
              else
                return nil
            end
    posts.reject do |post|
      (post.tags & current_post.tags).empty? || post == current_post
    end
  end

  # Returns all tags related with a post tags.
  def related_tags_in(folder = :posts)
    (related_posts_in(folder) << current_post).map{ |post| post.tags }.flatten.uniq.sort
  end

  # Returns all tags related with a post tags.
  def all_related_tags
    (all_posts + all_archived_posts).reject do |post|
      (post.tags & current_post.tags).empty?
    end.map{ |post| post.tags }.flatten.uniq.sort
  end

  # Count posts by tag name.
  def count_posts_by_tag(name)
    @count_posts_by_tag ||= all_tags.inject({}) do |count, tag|
      count[tag] = (all_posts + all_archived_posts).count{ |post| post.tags.include? tag }
      count
    end
    @count_posts_by_tag[name]
  end

end # module Helpers

end # module Postview

