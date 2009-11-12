# Copying (c) 2009 Hallison Batista
class Postview::CLI::CreateCommand #:nodoc: all

  include Postview::CLI::Command

  def initialize(path, arguments)
    @path, @arguments, @options = path, arguments, {}
  end

  def run
    parse_arguments
    load_default_settings
    build_settings
  end

  def self.run args
    if args.first =~ /^\w.*|^\/\w.*/
      new(args.shift, args.options).run
    else
      new(nil, args.options).run
    end
  end

private

  # Options for arguments.
  def options_for(name)
    { :help   => [ "-h", "--help", nil,
                   "Show this message." ],
      :prompt => [ "-p", "--prompt-values", nil,
                   "Enable ask for values." ],
      :yaml   => [ "-y", "--yaml YAML_TEXT", String,
                   "Load all settings from input YAML text."]
    }[name]
  end

  def parse_arguments
    @arguments.summary_indent = "  "
    @arguments.summary_width  = 24
    @arguments.banner = <<-end_banner.gsub(/^[ ]{6}/, '')
      #{Postview.version_summary}

      Usage:
        #{Postview.name.downcase} create <path>

    end_banner

    @arguments.separator "Create options:"

    @arguments.on(*options_for(:help))   { puts @arguments; exit 0 }
    @arguments.on(*options_for(:prompt)) { @options[:prompt] = true }
    @arguments.on(*options_for(:yaml)) do |yaml|
      @settings = Postview::Settings.new(YAML.load(yaml))
    end

    @arguments.separator ""

    begin
      unless @path
        puts @arguments
        exit 1
      else
        @arguments.parse!
      end
    rescue => error
      puts error
      puts @arguments
    end
    puts "#{Postview.version_summary}\n\n"
  end

  def build_settings
    create_root_path
    if @options[:prompt]
      prompt_for_site_settings
      prompt_for_directories_settings
      prompt_for_sections_settings
    end
    prompt_for_site_password
    create_settings
    create_directories
    create_default_theme
    create_rackup
    create_rakefile
  end

  def load_default_settings
    start "Loading default settings" do
      step { @settings    ||= Postview::Settings.load }
      step { @site          = @settings.site          }
      step { @directories   = @settings.directories   }
      step { @sections      = @settings.sections      }
      step { @theme_default = Postview::ROOT.join("themes", "default") }
    end
  end

  def create_root_path
    start "Creating #{@path} path" do
      step { @path = Pathname.new(@path) }
      step { @path.exist? ? raise("Path #{@path} exist") : true }
      step { @path.mkpath; true }
      step { @theme = @path.join("themes", "default") }
    end
  end

  def create_settings
    file = @path.join(Postview::Settings::FILE_DIR, Postview::Settings::FILE_NAME)
    start "Creating #{file}" do
      step { file.dirname.mkpath; true }
      step { file.dirname.exist? }
      file.open "w+" do |settings_file|
        settings = {}
        step { settings[:site]        = @site        }
        step { settings[:directories] = @directories }
        step { settings[:sections]    = @sections    }
        step { settings_file << settings.to_yaml     }
      end
      step { file.exist? }
    end
  end

  def create_directories
    create = lambda do |path|
      start "Creating #{path}" do
        # step { path.exist? ? raise("Directory path #{path} exist") : true } if check
        step { path.mkpath; true }
        step { path.exist? }
      end
    end

    @directories.keys.each do |dirname|
      create.call @path.join(@settings.directories[dirname])
    end

    %w{public tmp}.each do |dirname|
      create.call @path.join(dirname)
    end
  end

  def create_default_theme
    create_path @theme
    copy_default_theme @theme_default, @theme
  end

  def create_path(path)
    start "Creating #{path}" do
      step { path.exist? ? raise("Path #{path} exist") : true }
      step { path.mkpath; true }
      step { path.exist? }
    end
  end

  def copy_default_theme(origin, destination)
    origin.children.map do |origin_path|
      if origin_path.directory?
        destination_path = destination.join(origin_path.basename)
        create_path destination_path
        copy_default_theme origin_path, destination_path
      else
        copy_file origin_path, destination.join(origin_path.basename)
      end
    end
  end

  def copy_file(origin, destination)
    start "Creating #{destination}" do
      step { destination.exist? ? raise("Theme file #{destination} exist") : true }
      step { FileUtils.copy(origin, destination); true }
      step { destination.exist? }
    end
  end

  def create_rackup
    config = @path.join("config.ru")
    start "Creating #{config} file" do
      config.open("w+") do |rackup|
        step { rackup << "require 'rubygems'\n" }
        step { rackup << "require 'postview'\n" }
        #step { rackup << "log = File.open(\"tmp/postview.log\", \"a+\")\n" }
        #step { rackup << "$stdout.reopen(log)\n" }
        #step { rackup << "$stderr.reopen(log)\n" }
        step { rackup << "run Postview::Application::Blog\n" }
      end
    end
  end

  def create_rakefile
    rakefile = @path.join("rakefile")
    start "Creating #{rakefile}" do
      rakefile.open("w+") do |file|
        content = []
        content << "require 'postview'\n"
        content << "include Postview::CLI::Command\n"
        content << <<-'end_def'.gsub(/^[ ]{10}/, '')
          # Build default settings file and load.
          def settings
            Postview::Settings.load
          end
        end_def

        content << <<-'end_def'.gsub(/^[ ]{10}/, '')
          # Build and load the resource file for FTP connection.
          def netrc
            begin
              @netrc ||= File.readlines(File.join(ENV['HOME'],".netrc"))
            rescue Errno::ENOENT => message
              puts <<-end_message.gsub(/^[ ]{6}/,'')
                #{message}.
                Please create the .netrc file in your home.
                echo "\
                machine #{settings.site[:domain]}
                  login <username>
                  password <password>
                " >> #{ENV['HOME']}/.netrc
              end_message
              exit 1
            end
            match ||= @netrc.to_s.match(/machine (.*?)[\n ]login (.*?)[\n ]password (.*?)[\n ].*?/m)
            { :machine => match[1].strip, :login => match[2].strip, :password => match[3].strip }
          end
        end_def

        content << <<-'end_def'.gsub(/^[ ]{10}/, '')
          # Synchronize directory
          def ftp(directory, destination = nil)
            origin        = settings.directories[directory]
            destination ||= File.join(settings.site[:directory], settings.directories[directory])
            posts         = settings.build_finder_for(directory).all_posts

            $stdout.puts ">> Connecting to #{netrc[:machine]} ..."

            Net::FTP.open(netrc[:machine]) do |ftp|
              ftp.login netrc[:login], netrc[:password]

              $stdout.puts ">> Logged as #{netrc[:login]} ..."

              $stdout.puts ">> Accessing #{destination} ..."

              ftp.chdir destination

              posts.each do |post|
                $stdout.puts ">> Copying #{post} ..."
                ftp.putbinaryfile(File.join(origin, post.file))
              end

              $stdout.puts ">> Synchronization for #{directory} is done."
            end
          end
        end_def

        content << <<-'end_task'.gsub(/^[ ]{10}/, '')
          desc <<-end_desc.gsub(/^[ ]{2}/,'')
            Create new post in #{settings.path_to(:posts)}.
            For edit posts, set environment variable EDITOR or VISUAL. Otherwise,
            pass editor="<your favorite editor command and arguments>".

            Example:

            $ rake post editor="gvim -f"

            Or use directory argument for create a post in other directory.

            $ rake post[other/path/for/new/post]
          end_desc
          task :post, [:directory] do |spec, args|
            puts "New post. Type all attributes for new post.\n"
            path = if args.directory
                    if settings.directories.has_key? args.directory.to_sym 
                      settings.path_to(args.directory.to_sym)
                    else
                      args.directory
                    end
                  else
                    settings.path_to(:drafts)
                  end
            post = Postage::Post.new :title        => prompt("Post title"),
                                    :publish_date => prompt("Publish date", Date.today),
                                    :tags         => prompt("Tags separated by spaces").split(' '),
                                    :filter       => :markdown,
                                    :content      => <<-end_content.gsub(/^[ ]{28}/,'')
                                      Thanks for use #{Postview.version_summary}.
                                      Input here the content of your post.
                                    end_content

            begin
              post.build_file
              post.create_into(path)
            rescue Errno::ENOENT => message
              $stderr.puts message
              $stderr.puts "Try create path #{args.directory}."
              exit 1
            end

            printf "%s\n", "The post '#{post.title}' was created in '#{path}/#{post.file}'."

            editor = ENV['editor'] || ENV['EDITOR'] || ENV['VISUAL'] || 'none'
            if prompt("Edit post using '#{editor}'?", "y") =~ /y/i
              if editor
                sh "#{editor} #{path}/#{post.file}"
              else
                printf "%s", "Editor not specified."
              end
            end

            $stdout.puts ">> Post done."
          end
        end_task

        content << <<-'end_task'.gsub(/^[ ]{10}/, '')
          namespace :sync do
            settings.directories.keys.each do |dirname|
              desc "Synchronize #{dirname}."
              task dirname, [:destination] do |spec,args|
                puts "Synchronize #{dirname} directory."
                ftp(dirname, args.destination)
              end
            end

            desc "Synchronize all directories."
            task :all => settings.directories.keys
          end
        end_task

        content.each do |method|
          step { file << "#{method}\n" }
        end
      end
    end
  end

  def prompt_for_site_settings
    init "Settings for site information" do |site|
      site[:title]     = prompt "Title",       @settings.site[:title]
      site[:subtitle]  = prompt "Subtitle",    @settings.site[:subtitle]
      site[:author]    = prompt "Author name", @settings.site[:author]
      site[:email]     = prompt "Email",       @settings.site[:email],   %r{.*?@.*?\..*}
      site[:domain]    = prompt "Domain",      @settings.site[:domain],  %r{.*\..*}
      site[:directory] = prompt "Directory",   @settings.site[:directory]
      @site.update site
    end
  end

  def prompt_for_site_password
    init "Settings required for generate new token" do |site|
      site[:author] = prompt "Author name", @settings.site[:author]
      site[:domain] = prompt "Domain",      @settings.site[:domain],  %r{.*\..*}
      site[:token]  = Postview::Site.tokenize(site[:author], hidden_prompt("Password"), site[:domain])
      @site.update site
    end if @settings.site[:token] == Postview::Settings::DEFAULTS[:site][:token]
  end

  def prompt_for_directories_settings
    init "Settings for directories" do |directories|
      directories[:posts]   = prompt "Posts",   @settings.directories[:posts]
      directories[:archive] = prompt "Archive", @settings.directories[:archive]
      directories[:drafts]  = prompt "Drafts",  @settings.directories[:drafts]
      @directories.update directories
    end
  end

  def prompt_for_sections_settings
    init "Settings for sections" do |sections|
      sections[:root]    = prompt "Root",    @settings.sections[:root]
      sections[:posts]   = prompt "Posts",   @settings.sections[:posts]
      sections[:tags]    = prompt "Tags",    @settings.sections[:tags]
      sections[:archive] = prompt "Archive", @settings.sections[:archive]
      sections[:drafts]  = prompt "Drafts",  @settings.sections[:drafts]
      sections[:search]  = prompt "Search",  @settings.sections[:search]
      sections[:about]   = prompt "About",   @settings.sections[:about]
      @sections.update sections
    end
  end

end # class Postview::CLI::SetupCommand

