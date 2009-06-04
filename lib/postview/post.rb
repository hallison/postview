module Postview

  class Post

    attr_reader :publish_date, :title, :tags, :summary, :content, :filter, :file

    def initialize(file_name)
      extract_attributes(file_name)
    end

    def to_s
      @file.scan(%r{(\d{4})(\d{2})(\d{2})-(.*?)\..*}) do |year,month,day,name|
        return "#{year}/#{month}/#{day}/#{name}"
      end
    end

    def matched?(regexp)
      @title.match(regexp) || @file.match(regexp)
    end

  private

    def extract_attributes(file_name)
      extract_publish_date(file_name)
      extract_tags(file_name)
      extract_filter(file_name)
      extract_title_and_content(file_name)
      @file    = File.basename(file_name)
      @title   = @file.gsub('_', ' ').capitalize if @title.to_s.empty?
      @summary = @content.match(%r{<p>.*</p>}i).to_s
    end

    def extract_publish_date(file_name)
      file_name.scan(%r{(\d{4})(\d{2})(\d{2})-.*}) do |year,month,day|
        @publish_date = Date.new(year.to_i, month.to_i, day.to_i)
      end
    end

    def extract_title(file_name)
      Maruku.new(title).to_html.gsub(/<h1.*?>(.*)<\/h1>/){$1}
    end

    def extract_tags(file_name)
      @tags = file_name.scan(%r{.*?-.*?\.(.*)\..*}).to_s.split('.')
    end

    def extract_filter(file_name)
      file_name.scan(%r{.*\.(.*)}) do |filter|
        @filter = case filter.to_s
                  when /md|mkd|mark.*/
                    :markdown
                  when /tx|txt|text.*/
                    :textile
                  else
                    :none
                  end
      end
    end

    def find_file(year, month, day, name)
      # TOFIX: check posts directory
      Dir["#{year}#{month}#{day}-#{name}**.*"].first
    end

    def extract_title_and_content(file_name)
      _content = File.readlines(file_name)
      _title   = _content.shift
      _title  += _content.shift if (_content.first =~ /==/)
      @title   = Maruku.new(_title).to_html.gsub(/<h1.*?>(.*)<\/h1>/){$1}
      @content = Maruku.new(_content.to_s).to_html
    end

    def search_expresion(keywords)
      %r{#{keywords.to_s.split(/[ ,\*]/).join('|')}}i
    end

    def post_found?(post, regexp)
      @title.match(regexp) || @file.match(regexp)
    end

  end # class Post

end # module Postview

