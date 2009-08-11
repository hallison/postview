module Postview

# Copyright (c) 2009 Hallison Batista
module Helpers

  attr_reader :site, :page
  attr_reader :post, :posts, :archive, :tag, :tags

  # ...
  def count_posts_by_tag(tagname)
    @count_posts_by_tag ||= @tags.inject({}) do |hash, tag|
      hash[tag] = (@site.find.all_posts + @site.find_archived.all_posts).count{ |post| post.tags.include? tag }
      hash
    end
    @count_posts_by_tag[tagname]
  end

end # module Helpers

end # module Postview

