module Postview

# Copyright (c) 2009 Hallison Batista
module Application

  autoload :Blog,  'postview/application/blog'
  autoload :Setup, 'postview/application/setup'

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

end # module Application

end # module Postview

