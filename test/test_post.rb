$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")

require 'test/unit'
require 'lib/postview'

class TestPost < Test::Unit::TestCase

  def setup
    @attributes = {
      :publish_date => Date.new(2009, 06, 04),
      :title => "Postage test <em>post</em>\n",
      :tags => %w(ruby postage),
      :filter => :markdown,
      :file => "20090604-postage_test_post.ruby.postage.mkd"
    }
    @post = Postview::Post.new("#{File.dirname(__FILE__)}/fixtures/posts/20090604-postview_post_with_sinatra_markdown_and_rsync.ruby.sinatra.postview.mkd")
  end

  def test_should_load_attributes_from_file_name
    @attributes.each do |attribute, value|
      assert value, @post.send(attribute)
    end
  end

  def test_should_check_html_in_content
    assert_match %r{<p>.*?</p>}, @post.content
  end

end

