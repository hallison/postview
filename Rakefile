$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'lib/postview'
require 'net/ftp'
require 'rake/testtask'
require 'rake/packagetask'


# Show text message in console.
def banner(message)
  printf "\n%s\n", Postview
  printf "\n%s\n\n", message
end

# Prompt for values.
def prompt(label, default = nil)
  while true
    printf((default ? "%s [%s]: " : "%s: "), "#{label}", "#{default}")
    value = $stdin.readline.chomp.strip
    value = default if value.empty?
    return value unless value.nil? || value.to_s.empty?
  end
end

# Build default settings file and load.
def settings
  #Postview::Settings.build_default_file
  Postview::Settings.load
end

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

def rsync(directory, destination = nil)
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

desc <<-end_desc.gsub(/^[ ]{2}/,'')
  Create new post in #{settings.directory_for(:posts)}.
  For edit posts, set environment variable EDITOR or VISUAL. Otherwise,
  pass editor="<your favorite editor command and arguments>".

  Example:

  $ rake post editor="gvim -f"

  Or use directory argument for create a post in other directory.

  $ rake post[other/path/for/new/post]
end_desc
task :post, [:directory] do |spec, args|
  banner "New post. Type all attributes for new post.\n"
  path = if args.directory
           if settings.directories.has_key? args.directory.to_sym 
             settings.directory_for(args.directory.to_sym)
           else
             args.directory
           end
         else
           settings.directory_for(:drafts)
         end
  post = Postage::Post.new :title        => prompt("Post title"),
                           :publish_date => prompt("Publish date", Date.today),
                           :tags         => prompt("Tags separated by spaces").split(' '),
                           :filter       => :markdown,
                           :content      => <<-end_content.gsub(/^[ ]{29}/,'')
                             Tanks for use #{Postview}.
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

namespace :sync do
  settings.directories.keys.each do |dirname|
    desc "Synchronize #{dirname}."
    task dirname, [:destination] do |spec,args|
      banner "Synchronize #{dirname} directory."
      ftp(dirname, args.destination)
    end
  end

  desc "Synchronize all directories."
  task :all => settings.directories.keys
end

Dir["tasks/**.rake"].each do |task_file|
  load task_file
end

