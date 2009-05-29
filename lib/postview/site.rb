module Postview

  class Site

    # Attributes from settings.
    attr_reader :about, :directories, :paths
    # Attributes to application.
    attr_reader :posts, :tags

    def initialize(file_name)
      YAML.load_file(file_name).symbolize_keys.instance_variables_set_to(self)
      find_all_posts
      find_all_tags
    end

    def self.load
      new(File.join(PATH, *%w(config postview.yml)))
    end

    def find_all_posts(pattern = "**.*")
      Dir["#{directories[:posts]}/#{pattern}"].inject([]) do |@posts, file_name|
        $stdout.puts "Post #{file_name} loaded ..."
        @posts << extract_post(file_name)
      end
    end

    def find_all_posts_by_tag(tag)
      find_all_posts("**#{tag}**.*") if @posts.empty?
      @posts.find_all{ |post| post[:tags].keys.include?(tag) }
    end

    def find_all_tags
      @posts.inject({}) do |@tags, post|
        @tags.merge(post[:tags])
      end
    end

    def find_post(year, month, day, name)
      if @posts.empty?
        extract_post(find_post_file(year, month, day, name))
      else
        @posts.find{ |post| post[:file].match(%r{#{directories[:posts]}/#{year}#{month}#{day}-#{name}.*}i) }
      end
    end

    def search_posts(keywords)
      find_all_posts("**{#{keywords.join(',')}}**.*") if @posts.empty?
      @posts.find_all{ |post| post_found?(post, search_expresion(keywords)) }
    end

    def extract_post(file_name)
      file_name.scan(%r{/(\d{4})(\d{2})(\d{2})-(.*?)\.(.*)\.(mkd)}) do |year, month, day, name, tags, filter|
        post = {
          :publish_date => { :year => year, :month => month, :day => day },
          :tags         => extract_post_tags(tags),
          :title        => "Not loaded",
          :content      => "Not loaded",
          :file         => file_name,
          :filter       => filter,
          :path         => "/#{paths[:posts]}/#{year}/#{month}/#{day}/#{name}"
        }
        post[:title], post[:content] = extract_post_title_and_content(load_post_file(file_name))
        post[:title] = post[:file].gsub('_', ' ').capitalize if post[:title].to_s.empty?
        return post
      end
    end
    private :extract_post

    def extract_post_tags(string)
      string.split('.').inject({}) do |tags, name|
        tags[name] = "/#{paths[:tags]}/#{name}"
        tags
      end
    end

    def find_post_file(year, month, day, name)
      Dir["#{directories[:posts]}/#{year}#{month}#{day}-#{name}**.*"].first
    end
    private :find_post_file

    def load_post_file(file)
      File.read(file)
    end
    private :load_post_file

    def extract_post_title_and_content(string)
      title   = $1 if string.match(%r{(^.*?)\n})
      content = string.gsub(%r{#{title}\n}, '')
      [ Maruku.new(title).to_html.gsub(/<h1.*?>(.*)<\/h1>/){$1}, Maruku.new(content).to_html ]
    end
    private :extract_post_title_and_content

    def search_expresion(keywords)
      %r{#{keywords.to_s.split(/[ ,\*]/).join('|')}}i
    end
    private :search_expresion

    def post_found?(post, regexp)
      post[:title].match(regexp) || post[:file].match(regexp)
    end
    private :post_found?

  end # class Site

end #module Postview

