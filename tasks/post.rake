require 'readline'

desc <<-end
  Create new post in #{Postview::Settings.load.directory_for(:posts)}.
end
task :post do
  banner "New post. Type all attributes for new post."
  title        = prompt("Post title")
  publish_date = prompt("Publish date", Date.today)
  tags         = prompt("Tags separated by spaces")

  file_name = "#{publish_date.to_s.gsub(/-/,'')}-#{title.gsub(/\W/,'_').squeeze('_').downcase}.#{tags.gsub(' ','.')}.mkd"
  file_name = File.join(Postview::Settings.load.directory_for(:drafts), file_name)

  File.open file_name, "w" do |file|
    file << "#{title}\n"
    file << "="*title.size
  end

  printf "%s\n", "The post '#{title}' was created in '#{file_name}'."

  if prompt("Edit post?", "y") =~ /y/i
    editor = ENV['EDITOR'] || ENV['VISUAL']
    if editor
      sh "#{editor} #{file_name}"
    else
      printf "%s", "Editor not specified."
    end
  end

end

