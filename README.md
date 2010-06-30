Postview - A lightweight blog engine
====================================

Postview is a simple blog engine (a.k.a. blogware) written in [Ruby][] using
the [Sinatra][] framework and [Kramdown][] parser to renders files written in
[Markdown][].

Features
--------

* Easy configuration.
* Easy synchronization.
* No database, it's use only text files written in [Markdown][].
* Has suport to themes.

Getting started
---------------

Install [Ruby][] [Gem package][postview gem] and try.

The Postview depended of the following libraries (Gems):

* [Sinatra][]
* [Sinatra-Mapping][]
* [Postage][]

Install stable gem from [RubyForge][] or [GemCutter.org][].

    $ sudo gem install postview

Then, run command for create and setup a new Postview directory structure.

    $ postview create path/to/blog

Or run using "--prompt-values":

    $ postview create path/to/blog --prompt-values

After setup, run server with command:

    $ postview server

In your browser, access http://127.0.0.1:9000/.

### How it works

The Postview creates a directory structure like this:

    .
    |-- config
    |-- posts
    |   |-- archive
    |   `-- drafts
    |-- public
    |-- themes
    |   `-- default
    |       |-- images
    |       |-- stylesheets
    |       `-- templates
    |           |-- archive
    |           |-- drafts
    |           |-- posts
    |           `-- tags
    `-- tmp

### Create new post

New post can be created by using the task `post`:

    $ cd path/to/postview
    $ rake post

Following all instructions. Please, set environment variable +EDITOR+
or +VISUAL+ for editing your posts. Other else, run:

    $ cd path/to/postview
    $ EDITOR=<your-favorite-editor> rake post

The new post will be written in drafts directory. You can pass other
directory.

    $ cd path/to/postview
    $ rake post[path/to/other/post/directory]

NOTE: New feature for creates new post from blog manager will be added.

Synchronize your posts
----------------------

Postview use by default FTP method for synchronization. But, is possible make
deploy using [Heroku][] and [Git][].


### FTP

You can synchronize your files using the . For more information about
this task, run <code>rake -D sync</code>.

It's need creates and edit file placed in `/your/home/directory/.netrc`.
The `directory` attribute most be setted in `settings.yml` file.

Example:

    # remote host
    /remote/path/to/postview
    `-- posts
        |-- archive
        `-- drafts
    # local host
    posts
    |-- 20090702-foo_post_article.ruby.sinatra.git.mkd
    |-- archive
    |   `-- 20080702-foo_post_article.ruby.sinatra.git.mkd
    `-- drafts
        `-- 20090703-foo_draft_article.ruby.sinatra.git.mkd

    # To synchronize posts
    $ rake sync:posts
    $ rake sync:posts[remote/path/to/postview/posts]

    # To synchronize archive
    $ rake sync:archive
    $ rake sync:archive[remote/path/to/postview/posts/archive]

    # To synchronize drafts
    $ rake sync:drafts
    $ rake sync:drafts[remote/path/to/postview/posts/drafts]

    # To synchronize all
    $ rake sync:all

NOTE: Will added new enhancements for this feature.

[ruby]: http://www.ruby-lang.org 
  "Ruby Programming Language"

[sinatra]: http://www.sinatrarb.com/
  "Sinatra - Classy web framework"

[kramdown]: http://kramdown.rubyforge.org/
  "Kramdown - Markdown superset converter"

[markdown]: http://daringfireball.net/projects/markdown
  "Markdown - The lightweight markup language"

[sinatra-mapping]: http://sinatra-mapping.rubyforge.org
  "Sinatra::Mapping - Extension to map URL paths in Sinatra"

[postage]: http://postage.rubyforge.org/
  "Postage - Postview base for parse text files"

[rubyforge]: http://rubyforge.org/
  "RubyForge.org"

[gemcutter]: http://gemcutter.org/
  "GemCutter.org"

[heroku]: http://heroku.com
  "Heroku"

[git]: http://git-scm.com
  "Git"
