# Copyright (c) 2009 Hallison Batista
module Postview::Application

  autoload :Blog,  'postview/application/blog'
  autoload :Build, 'postview/application/build'

  def self.call(env)
    puts <<-end_msg.gsub(/^[ ]{6}/,'')
      #{Postview::version_summary}
      >> DEPRECATION WARNING
         The run Postview::Application is deprecated. Instead use
         Postview::Application::Blog to call blogware.

         Thanks.
         
         Visit http://github.com/hallison/postview/tree/news for more information.
    end_msg
    Blog.call(env)
  end

end # module Postview::Application

