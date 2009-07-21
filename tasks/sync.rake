require 'net/ftp'

def netrc
  begin
    @netrc ||= File.readlines(File.join(ENV['HOME'],".netrc"))
  rescue Errno::ENOENT => message
    puts <<-end_message.gsub(/^[ ]{6}/,'')
      #{message}.
      Please create the .netrc file in your home.
      echo "\
      machine <example.com>
        login <username>
        password <password>
      " >> $HOME/.netrc
    end_message
    exit 1
  end
  match ||= @netrc.to_s.match(/machine (.*?)[\n ]login (.*?)[\n ]password (.*?)[\n ].*?/m)
  { :machine => match[1].strip, :login => match[2].strip, :password => match[3].strip }
end

desc <<-end_desc.gsub(/^  /,'')
  FTP connection for synchronise. Please, create and edit file
  #{ENV['HOME']}/.netrc. The directory argument most be setted in
  #{Postview::ROOT}/config/settings.yml.
end_desc

task :sync, [:origin,:destination] do |taskspec, dir|
  settings    = Postview::Settings.load
  origin_path = settings.directories[dir.origin.to_sym]
  posts       = settings.build_finder_for(dir.origin.to_sym).all_posts

  unless dir.destination
    $stdout.puts ">> Origin and destination directories are mandatory."
    $stdout.puts ">> Usage:"
    $stdout.puts ">> $ rake #{taskspec.name}[<origin>,<destination>]"
    exit 1
  end

  $stdout.puts ">> Connecting to #{netrc[:machine]} ..."

  Net::FTP.open(netrc[:machine]) do |ftp|
    ftp.login netrc[:login], netrc[:password]

    $stdout.puts ">> Logged as #{netrc[:login]} ..."

    ftp.chdir dir.destination

    posts.each do |post|
      $stdout.puts ">> Copying #{post} ..."
      ftp.putbinaryfile(File.join(origin_path, post.file))
    end

    $stdout.puts ">> Done"
  end
end

