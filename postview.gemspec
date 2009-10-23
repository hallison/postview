--- !ruby/object:Gem::Specification 
name: postview
version: !ruby/object:Gem::Version 
  version: 0.9.0
platform: ruby
authors: 
- Hallison Batista
autorequire: 
bindir: bin
cert_chain: []

date: 2009-10-14 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: sinatra
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: 0.9.1.1
    version: 
- !ruby/object:Gem::Dependency 
  name: sinatra-mapping
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: 1.0.5
    version: 
- !ruby/object:Gem::Dependency 
  name: postage
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: 0.1.4.1
    version: 
description: Postview is a simple blogware written in Ruby using the Sinatra DSL for render files written in Markdown.
email: email@hallisonbatista.com
executables: 
- postview
extensions: []

extra_rdoc_files: 
- README.rdoc
- LICENSE
files: 
- ABOUT
- HISTORY
- LICENSE
- Rakefile
- VERSION
- README.rdoc
- bin/postview
- lib/postview/settings.rb
- lib/postview/cli/server_command.rb
- lib/postview/cli/create_command.rb
- lib/postview/version.rb
- lib/postview/site.rb
- lib/postview/application.rb
- lib/postview/patches.rb
- lib/postview/authentication.rb
- lib/postview/cli.rb
- lib/postview/helpers.rb
- lib/postview/extensions.rb
- lib/postview.rb
- tasks/homepage.rake
- tasks/version.rake
- tasks/documentation.rake
- tasks/package.rake
- tasks/history.rake
- test/customizations.rb
- test/site_test.rb
- test/helpers_test.rb
- test/settings_test.rb
- test/application_test.rb
- test/fixtures/application
- test/fixtures/application/posts
- test/fixtures/application/posts/archive
- test/fixtures/application/posts/archive/20080602-second_article.t1.t2.mkd
- test/fixtures/application/posts/archive/20080529-first_article.t1.mkd
- test/fixtures/application/posts/20090602-fourth_article.t1.t2.t3.t4.mkd
- test/fixtures/application/posts/drafts
- test/fixtures/application/posts/drafts/20090730-fifth_article.t1.t2.t3.t4.t5.mkd
- test/fixtures/application/posts/20090529-third_article.t1.t2.t3.mkd
- test/fixtures/application/config
- test/fixtures/application/config/settings.yml
- test/fixtures/application/empty.yml
- test/fixtures/application/themes
- test/fixtures/application/themes/mytheme
- test/fixtures/application/themes/mytheme/templates
- test/fixtures/application/themes/mytheme/templates/search.erb
- test/fixtures/application/themes/mytheme/templates/posts
- test/fixtures/application/themes/mytheme/templates/posts/index.erb
- test/fixtures/application/themes/mytheme/templates/posts/show.erb
- test/fixtures/application/themes/mytheme/templates/error.erb
- test/fixtures/application/themes/mytheme/templates/layout.erb
- test/fixtures/application/themes/mytheme/templates/tags
- test/fixtures/application/themes/mytheme/templates/tags/index.erb
- test/fixtures/application/themes/mytheme/templates/tags/show.erb
- test/fixtures/application/themes/mytheme/templates/archive
- test/fixtures/application/themes/mytheme/templates/archive/index.erb
- test/fixtures/application/themes/mytheme/templates/archive/show.erb
- test/fixtures/application/themes/mytheme/templates/index.erb
- test/fixtures/application/themes/mytheme/templates/about.erb
- test/fixtures/application/themes/mytheme/templates/drafts
- test/fixtures/application/themes/mytheme/templates/drafts/index.erb
- test/fixtures/application/themes/mytheme/templates/drafts/show.erb
- test/fixtures/application/themes/mytheme/stylesheets
- test/fixtures/application/themes/mytheme/stylesheets/gemstone.css
- test/fixtures/application/themes/mytheme/stylesheets/postview.css
- test/fixtures/application/themes/mytheme/javascripts
- test/fixtures/application/themes/mytheme/javascripts/postview.js
- test/fixtures/application/themes/mytheme/images
- test/fixtures/application/themes/mytheme/images/rack.png
- test/fixtures/application/themes/mytheme/images/ruby.png
- test/fixtures/application/themes/mytheme/images/trojan.com
- test/fixtures/application/themes/mytheme/images/logo.png
- test/fixtures/application/themes/mytheme/images/navigation-bar.gif
- test/fixtures/application/themes/mytheme/images/banners
- test/fixtures/application/themes/mytheme/images/banners/banner.jpg
- test/fixtures/application/themes/mytheme/images/favicon.ico
- test/fixtures/application/themes/mytheme/images/sinatra.png
- test/fixtures/application/themes/mytheme/images/postview.png
- test/fixtures/application/config.ru
- test/fixtures/site
- test/fixtures/site/themes
- test/fixtures/site/themes/mytheme
- test/fixtures/site/themes/mytheme/templates
- test/fixtures/site/themes/mytheme/templates/search.erb
- test/fixtures/site/themes/mytheme/templates/posts
- test/fixtures/site/themes/mytheme/templates/posts/index.erb
- test/fixtures/site/themes/mytheme/templates/posts/show.erb
- test/fixtures/site/themes/mytheme/templates/error.erb
- test/fixtures/site/themes/mytheme/templates/layout.erb
- test/fixtures/site/themes/mytheme/templates/tags
- test/fixtures/site/themes/mytheme/templates/tags/index.erb
- test/fixtures/site/themes/mytheme/templates/tags/show.erb
- test/fixtures/site/themes/mytheme/templates/archive
- test/fixtures/site/themes/mytheme/templates/archive/index.erb
- test/fixtures/site/themes/mytheme/templates/archive/show.erb
- test/fixtures/site/themes/mytheme/templates/index.erb
- test/fixtures/site/themes/mytheme/templates/about.erb
- test/fixtures/site/themes/mytheme/templates/drafts
- test/fixtures/site/themes/mytheme/templates/drafts/index.erb
- test/fixtures/site/themes/mytheme/templates/drafts/show.erb
- test/fixtures/site/themes/mytheme/stylesheets
- test/fixtures/site/themes/mytheme/stylesheets/gemstone.css
- test/fixtures/site/themes/mytheme/stylesheets/postview.css
- test/fixtures/site/themes/mytheme/javascripts
- test/fixtures/site/themes/mytheme/javascripts/postview.js
- test/fixtures/site/themes/mytheme/images
- test/fixtures/site/themes/mytheme/images/rack.png
- test/fixtures/site/themes/mytheme/images/ruby.png
- test/fixtures/site/themes/mytheme/images/trojan.com
- test/fixtures/site/themes/mytheme/images/logo.png
- test/fixtures/site/themes/mytheme/images/navigation-bar.gif
- test/fixtures/site/themes/mytheme/images/banners
- test/fixtures/site/themes/mytheme/images/banners/banner.jpg
- test/fixtures/site/themes/mytheme/images/favicon.ico
- test/fixtures/site/themes/mytheme/images/sinatra.png
- test/fixtures/site/themes/mytheme/images/postview.png
- test/fixtures/site/blog
- test/fixtures/site/blog/posts
- test/fixtures/site/blog/posts/archive
- test/fixtures/site/blog/posts/archive/20080602-second_article.t1.t2.mkd
- test/fixtures/site/blog/posts/archive/20080529-first_article.t1.mkd
- test/fixtures/site/blog/posts/20090602-fourth_article.t1.t2.t3.t4.mkd
- test/fixtures/site/blog/posts/drafts
- test/fixtures/site/blog/posts/drafts/20090730-fifth_article.t1.t2.t3.t4.t5.mkd
- test/fixtures/site/blog/posts/20090529-third_article.t1.t2.t3.mkd
- test/fixtures/site/blog/config
- test/fixtures/site/blog/config/settings.yml
- test/fixtures/site/blog/empty.yml
- test/fixtures/site/blog/config.ru
- themes/default
- themes/default/templates
- themes/default/templates/search.erb
- themes/default/templates/posts
- themes/default/templates/posts/index.erb
- themes/default/templates/posts/show.erb
- themes/default/templates/error.erb
- themes/default/templates/layout.erb
- themes/default/templates/tags
- themes/default/templates/tags/index.erb
- themes/default/templates/tags/show.erb
- themes/default/templates/archive
- themes/default/templates/archive/index.erb
- themes/default/templates/archive/show.erb
- themes/default/templates/index.erb
- themes/default/templates/about.erb
- themes/default/templates/drafts
- themes/default/templates/drafts/index.erb
- themes/default/templates/drafts/show.erb
- themes/default/stylesheets
- themes/default/stylesheets/postview.css
- themes/default/images
- themes/default/images/rack.png
- themes/default/images/ruby.png
- themes/default/images/logo.png
- themes/default/images/navigation-bar.gif
- themes/default/images/favicon.ico
- themes/default/images/sinatra.png
- themes/default/images/postview.png
has_rdoc: true
homepage: http://postview.rubyforge.org/
licenses: []

post_install_message: |
  ------------------------------------------------------------------------------
  Postview v0.9.0 (October 14, 2009, Beta)
  
  Thanks for use this lightweight blogware. Now, you can read your posts by
  editing in your favorite editor.
  
  Please, feedback in http://github.com/hallison/postview/issues.
  ------------------------------------------------------------------------------

rdoc_options: 
- --line-numbers
- --inline-source
- --title
- Postview v0.9.0 (October 14, 2009, Beta)
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubyforge_project: postview
rubygems_version: 1.3.5
signing_key: 
specification_version: 3
summary: Simple blogware that render Markdown files.
test_files: 
- test/customizations.rb
- test/site_test.rb
- test/helpers_test.rb
- test/settings_test.rb
- test/application_test.rb
- test/fixtures/application
- test/fixtures/application/posts
- test/fixtures/application/posts/archive
- test/fixtures/application/posts/archive/20080602-second_article.t1.t2.mkd
- test/fixtures/application/posts/archive/20080529-first_article.t1.mkd
- test/fixtures/application/posts/20090602-fourth_article.t1.t2.t3.t4.mkd
- test/fixtures/application/posts/drafts
- test/fixtures/application/posts/drafts/20090730-fifth_article.t1.t2.t3.t4.t5.mkd
- test/fixtures/application/posts/20090529-third_article.t1.t2.t3.mkd
- test/fixtures/application/config
- test/fixtures/application/config/settings.yml
- test/fixtures/application/empty.yml
- test/fixtures/application/themes
- test/fixtures/application/themes/mytheme
- test/fixtures/application/themes/mytheme/templates
- test/fixtures/application/themes/mytheme/templates/search.erb
- test/fixtures/application/themes/mytheme/templates/posts
- test/fixtures/application/themes/mytheme/templates/posts/index.erb
- test/fixtures/application/themes/mytheme/templates/posts/show.erb
- test/fixtures/application/themes/mytheme/templates/error.erb
- test/fixtures/application/themes/mytheme/templates/layout.erb
- test/fixtures/application/themes/mytheme/templates/tags
- test/fixtures/application/themes/mytheme/templates/tags/index.erb
- test/fixtures/application/themes/mytheme/templates/tags/show.erb
- test/fixtures/application/themes/mytheme/templates/archive
- test/fixtures/application/themes/mytheme/templates/archive/index.erb
- test/fixtures/application/themes/mytheme/templates/archive/show.erb
- test/fixtures/application/themes/mytheme/templates/index.erb
- test/fixtures/application/themes/mytheme/templates/about.erb
- test/fixtures/application/themes/mytheme/templates/drafts
- test/fixtures/application/themes/mytheme/templates/drafts/index.erb
- test/fixtures/application/themes/mytheme/templates/drafts/show.erb
- test/fixtures/application/themes/mytheme/stylesheets
- test/fixtures/application/themes/mytheme/stylesheets/gemstone.css
- test/fixtures/application/themes/mytheme/stylesheets/postview.css
- test/fixtures/application/themes/mytheme/javascripts
- test/fixtures/application/themes/mytheme/javascripts/postview.js
- test/fixtures/application/themes/mytheme/images
- test/fixtures/application/themes/mytheme/images/rack.png
- test/fixtures/application/themes/mytheme/images/ruby.png
- test/fixtures/application/themes/mytheme/images/trojan.com
- test/fixtures/application/themes/mytheme/images/logo.png
- test/fixtures/application/themes/mytheme/images/navigation-bar.gif
- test/fixtures/application/themes/mytheme/images/banners
- test/fixtures/application/themes/mytheme/images/banners/banner.jpg
- test/fixtures/application/themes/mytheme/images/favicon.ico
- test/fixtures/application/themes/mytheme/images/sinatra.png
- test/fixtures/application/themes/mytheme/images/postview.png
- test/fixtures/application/config.ru
- test/fixtures/site
- test/fixtures/site/themes
- test/fixtures/site/themes/mytheme
- test/fixtures/site/themes/mytheme/templates
- test/fixtures/site/themes/mytheme/templates/search.erb
- test/fixtures/site/themes/mytheme/templates/posts
- test/fixtures/site/themes/mytheme/templates/posts/index.erb
- test/fixtures/site/themes/mytheme/templates/posts/show.erb
- test/fixtures/site/themes/mytheme/templates/error.erb
- test/fixtures/site/themes/mytheme/templates/layout.erb
- test/fixtures/site/themes/mytheme/templates/tags
- test/fixtures/site/themes/mytheme/templates/tags/index.erb
- test/fixtures/site/themes/mytheme/templates/tags/show.erb
- test/fixtures/site/themes/mytheme/templates/archive
- test/fixtures/site/themes/mytheme/templates/archive/index.erb
- test/fixtures/site/themes/mytheme/templates/archive/show.erb
- test/fixtures/site/themes/mytheme/templates/index.erb
- test/fixtures/site/themes/mytheme/templates/about.erb
- test/fixtures/site/themes/mytheme/templates/drafts
- test/fixtures/site/themes/mytheme/templates/drafts/index.erb
- test/fixtures/site/themes/mytheme/templates/drafts/show.erb
- test/fixtures/site/themes/mytheme/stylesheets
- test/fixtures/site/themes/mytheme/stylesheets/gemstone.css
- test/fixtures/site/themes/mytheme/stylesheets/postview.css
- test/fixtures/site/themes/mytheme/javascripts
- test/fixtures/site/themes/mytheme/javascripts/postview.js
- test/fixtures/site/themes/mytheme/images
- test/fixtures/site/themes/mytheme/images/rack.png
- test/fixtures/site/themes/mytheme/images/ruby.png
- test/fixtures/site/themes/mytheme/images/trojan.com
- test/fixtures/site/themes/mytheme/images/logo.png
- test/fixtures/site/themes/mytheme/images/navigation-bar.gif
- test/fixtures/site/themes/mytheme/images/banners
- test/fixtures/site/themes/mytheme/images/banners/banner.jpg
- test/fixtures/site/themes/mytheme/images/favicon.ico
- test/fixtures/site/themes/mytheme/images/sinatra.png
- test/fixtures/site/themes/mytheme/images/postview.png
- test/fixtures/site/blog
- test/fixtures/site/blog/posts
- test/fixtures/site/blog/posts/archive
- test/fixtures/site/blog/posts/archive/20080602-second_article.t1.t2.mkd
- test/fixtures/site/blog/posts/archive/20080529-first_article.t1.mkd
- test/fixtures/site/blog/posts/20090602-fourth_article.t1.t2.t3.t4.mkd
- test/fixtures/site/blog/posts/drafts
- test/fixtures/site/blog/posts/drafts/20090730-fifth_article.t1.t2.t3.t4.t5.mkd
- test/fixtures/site/blog/posts/20090529-third_article.t1.t2.t3.mkd
- test/fixtures/site/blog/config
- test/fixtures/site/blog/config/settings.yml
- test/fixtures/site/blog/empty.yml
- test/fixtures/site/blog/config.ru
