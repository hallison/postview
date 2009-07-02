$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'test/unit'
require 'lib/postview'

class TestPost < Test::Unit::TestCase

  def setup
    @attributes = {
      :publish_date => Date.new(2009, 06, 02),
      :title => "Postview - Blogware",
      :tags => %w(ruby sinatra),
      :filter => :markdown,
      :file => "20090602-postview_blogware.ruby.sinatra.mkd"
    }
    @post = Postview::Post.new("#{File.dirname(__FILE__)}/fixtures/posts/20090602-postview_blogware.ruby.sinatra.mkd")
  end

  def test_should_load_attributes_from_file_name
    @attributes.each do |attribute, value|
      assert_equal value, @post.send(attribute)
    end
  end

  def test_should_check_html_in_content
    assert_match %r{<p>.*?</p>}, @post.content
  end

end

