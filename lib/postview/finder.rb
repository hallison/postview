module Postview

  class Finder

    attr_reader :archive, :posts, :tags

    def initialize(files)
      @files = files
    end

    def build_all_posts_files
      @files.sort.collect do |file_name|
        Post.new(file_name)
      end
    end

    def all_posts
      @posts ||= build_all_posts_files
    end

    def all_posts_by_tag(tag)
      all_posts
      @posts.find_all{ |post| post.tags.include?(tag) }
    end

    def post(year, month, day, name)
      all_posts
      @posts.find{ |post| post.file.match(%r{#{year}#{month}#{day}-#{name}.*}i) }
    end

    def posts(keywords)
      all_posts
      @posts.find_all{ |post| post.matched? search_expresion(keywords) }
    end

    def all_post_tags
      all_posts
      @tags ||= @posts.collect{ |post| post.tags }.flatten.uniq
    end

    def all_tags
      all_post_tags
    end

    def tag(name)
      all_tags
      @tags.find{ |tag| tag == name }
    end

  private

    def search_expresion(keywords)
      %r{#{keywords.to_s.split(/[ ,\*]/).join('|')}}i
    end

  end # class Finder

end # module Postview

