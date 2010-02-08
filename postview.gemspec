Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY

  #about
  spec.name = "postview"
  spec.summary = "Postview is a simple blogware that render Markdown files."
  spec.description = "Postview is a simple blogware written in Ruby using the Sinatra DSL for render files written in Markdown."
  spec.authors = ["Hallison Batista"]
  spec.email = "email@hallisonbatista.com"
  spec.homepage = "http://postage.rubyforge.org/"
  #

  #version
  spec.version = "0.10.0"
  spec.date = "2009-10-26"
  #

  #dependencies
  spec.add_dependency "postage"
  spec.add_dependency "sinatra-mapping"
  #

  #manifest
  spec.files = [
    "ABOUT",
    "CHANGELOG",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "bin/postview",
    "lib/postview.rb",
    "lib/postview/application.rb",
    "lib/postview/application/blog.rb",
    "lib/postview/application/build.rb",
    "lib/postview/application/share/images/gradient-bottom-1x24.png",
    "lib/postview/application/share/images/gradient-top-1x24.png",
    "lib/postview/application/share/images/postview-icon.png",
    "lib/postview/application/share/images/postview-logo.png",
    "lib/postview/application/share/stylesheets/postview.css",
    "lib/postview/application/share/stylesheets/wappit",
    "lib/postview/application/views/build.erb",
    "lib/postview/application/views/layout.erb",
    "lib/postview/authentication.rb",
    "lib/postview/cli.rb",
    "lib/postview/cli/create_command.rb",
    "lib/postview/cli/server_command.rb",
    "lib/postview/compatibility.rb",
    "lib/postview/extensions.rb",
    "lib/postview/helpers.rb",
    "lib/postview/settings.rb",
    "lib/postview/site.rb",
    "postview.gemspec",
    "test/application_blog_test.rb",
    "test/application_build_test.rb",
    "test/customizations.rb",
    "test/fixtures/blog/config/settings.yml",
    "test/fixtures/blog/posts/20090529-third_article.t1.t2.t3.mkd",
    "test/fixtures/blog/posts/20090602-fourth_article.t1.t2.t3.t4.mkd",
    "test/fixtures/blog/posts/archive/20080529-first_article.t1.mkd",
    "test/fixtures/blog/posts/archive/20080602-second_article.t1.t2.mkd",
    "test/fixtures/blog/posts/drafts/20090730-fifth_article.t1.t2.t3.t4.t5.mkd",
    "test/fixtures/blog/themes/mytheme/images/banners/banner.jpg",
    "test/fixtures/blog/themes/mytheme/images/favicon.ico",
    "test/fixtures/blog/themes/mytheme/images/logo.png",
    "test/fixtures/blog/themes/mytheme/images/navigation-bar.gif",
    "test/fixtures/blog/themes/mytheme/images/postview.png",
    "test/fixtures/blog/themes/mytheme/images/rack.png",
    "test/fixtures/blog/themes/mytheme/images/ruby.png",
    "test/fixtures/blog/themes/mytheme/images/sinatra.png",
    "test/fixtures/blog/themes/mytheme/images/trojan.com",
    "test/fixtures/blog/themes/mytheme/javascripts/postview.js",
    "test/fixtures/blog/themes/mytheme/stylesheets/gemstone.css",
    "test/fixtures/blog/themes/mytheme/stylesheets/postview.css",
    "test/fixtures/blog/themes/mytheme/templates/about.erb",
    "test/fixtures/blog/themes/mytheme/templates/archive/index.erb",
    "test/fixtures/blog/themes/mytheme/templates/archive/show.erb",
    "test/fixtures/blog/themes/mytheme/templates/drafts/index.erb",
    "test/fixtures/blog/themes/mytheme/templates/drafts/show.erb",
    "test/fixtures/blog/themes/mytheme/templates/error.erb",
    "test/fixtures/blog/themes/mytheme/templates/index.erb",
    "test/fixtures/blog/themes/mytheme/templates/layout.erb",
    "test/fixtures/blog/themes/mytheme/templates/posts/index.erb",
    "test/fixtures/blog/themes/mytheme/templates/posts/show.erb",
    "test/fixtures/blog/themes/mytheme/templates/search.erb",
    "test/fixtures/blog/themes/mytheme/templates/tags/index.erb",
    "test/fixtures/blog/themes/mytheme/templates/tags/show.erb",
    "test/fixtures/empty.yml",
    "test/fixtures/incomplete.yml",
    "test/fixtures/site/blog/config/settings.yml",
    "test/fixtures/site/blog/posts/20090529-third_article.t1.t2.t3.mkd",
    "test/fixtures/site/blog/posts/20090602-fourth_article.t1.t2.t3.t4.mkd",
    "test/fixtures/site/blog/posts/archive/20080529-first_article.t1.mkd",
    "test/fixtures/site/blog/posts/archive/20080602-second_article.t1.t2.mkd",
    "test/fixtures/site/blog/posts/drafts/20090730-fifth_article.t1.t2.t3.t4.t5.mkd",
    "test/fixtures/site/blog/themes/mytheme/images/banners/banner.jpg",
    "test/fixtures/site/blog/themes/mytheme/images/favicon.ico",
    "test/fixtures/site/blog/themes/mytheme/images/logo.png",
    "test/fixtures/site/blog/themes/mytheme/images/navigation-bar.gif",
    "test/fixtures/site/blog/themes/mytheme/images/postview.png",
    "test/fixtures/site/blog/themes/mytheme/images/rack.png",
    "test/fixtures/site/blog/themes/mytheme/images/ruby.png",
    "test/fixtures/site/blog/themes/mytheme/images/sinatra.png",
    "test/fixtures/site/blog/themes/mytheme/images/trojan.com",
    "test/fixtures/site/blog/themes/mytheme/javascripts/postview.js",
    "test/fixtures/site/blog/themes/mytheme/stylesheets/gemstone.css",
    "test/fixtures/site/blog/themes/mytheme/stylesheets/postview.css",
    "test/fixtures/site/blog/themes/mytheme/templates/about.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/archive/index.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/archive/show.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/drafts/index.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/drafts/show.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/error.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/index.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/layout.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/posts/index.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/posts/show.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/search.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/tags/index.erb",
    "test/fixtures/site/blog/themes/mytheme/templates/tags/show.erb",
    "test/fixtures/site/themes/mytheme/images/banners/banner.jpg",
    "test/fixtures/site/themes/mytheme/images/favicon.ico",
    "test/fixtures/site/themes/mytheme/images/logo.png",
    "test/fixtures/site/themes/mytheme/images/navigation-bar.gif",
    "test/fixtures/site/themes/mytheme/images/postview.png",
    "test/fixtures/site/themes/mytheme/images/rack.png",
    "test/fixtures/site/themes/mytheme/images/ruby.png",
    "test/fixtures/site/themes/mytheme/images/sinatra.png",
    "test/fixtures/site/themes/mytheme/images/trojan.com",
    "test/fixtures/site/themes/mytheme/javascripts/postview.js",
    "test/fixtures/site/themes/mytheme/stylesheets/gemstone.css",
    "test/fixtures/site/themes/mytheme/stylesheets/postview.css",
    "test/fixtures/site/themes/mytheme/templates/about.erb",
    "test/fixtures/site/themes/mytheme/templates/archive/index.erb",
    "test/fixtures/site/themes/mytheme/templates/archive/show.erb",
    "test/fixtures/site/themes/mytheme/templates/drafts/index.erb",
    "test/fixtures/site/themes/mytheme/templates/drafts/show.erb",
    "test/fixtures/site/themes/mytheme/templates/error.erb",
    "test/fixtures/site/themes/mytheme/templates/index.erb",
    "test/fixtures/site/themes/mytheme/templates/layout.erb",
    "test/fixtures/site/themes/mytheme/templates/posts/index.erb",
    "test/fixtures/site/themes/mytheme/templates/posts/show.erb",
    "test/fixtures/site/themes/mytheme/templates/search.erb",
    "test/fixtures/site/themes/mytheme/templates/tags/index.erb",
    "test/fixtures/site/themes/mytheme/templates/tags/show.erb",
    "test/helpers_test.rb",
    "test/settings_test.rb",
    "test/site_test.rb",
    "themes/default/images/favicon.ico",
    "themes/default/images/logo.png",
    "themes/default/images/navigation-bar.gif",
    "themes/default/images/postview.png",
    "themes/default/images/rack.png",
    "themes/default/images/ruby.png",
    "themes/default/images/sinatra.png",
    "themes/default/stylesheets/postview.css",
    "themes/default/templates/about.erb",
    "themes/default/templates/archive/index.erb",
    "themes/default/templates/archive/show.erb",
    "themes/default/templates/drafts/index.erb",
    "themes/default/templates/drafts/show.erb",
    "themes/default/templates/error.erb",
    "themes/default/templates/index.erb",
    "themes/default/templates/layout.erb",
    "themes/default/templates/posts/index.erb",
    "themes/default/templates/posts/show.erb",
    "themes/default/templates/search.erb",
    "themes/default/templates/tags/index.erb",
    "themes/default/templates/tags/show.erb"
  ]
  #

  spec.test_files = spec.files.select{ |path| path =~ /^test\/*test*/ }

  spec.require_paths = ["lib"]

  #documentation
  spec.has_rdoc = true
  spec.extra_rdoc_files = [
    "COPYING",
    "CHANGELOG"
  ]
  spec.rdoc_options = [
    "--inline-source",
    "--line-numbers",
    "--charset", "utf8",
    "--main", "Postview",
    "--title", "Postview API Documentation"
  ]

  #rubygems
  spec.rubyforge_project = spec.name
  spec.post_install_message = <<-end_message.gsub(/^[ ]{4}/,'')
    #{'-'*78}
    #{Postview::Version}

    Thanks for use this lightweight blog-engine. Now, you can read your posts by
    editing in your favorite editor.

    Please, feedback in http://github.com/hallison/postview/issues.
    #{'-'*78}
  end_message
  #
end

