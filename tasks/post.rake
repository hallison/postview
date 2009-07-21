require 'readline'

desc <<-end_desc.gsub(/^[ ]{2}/,'')
  Create new post in #{Postview::Settings.load.directory_for(:posts)}.
  For edit posts, set environment variable EDITOR or VISUAL. Otherwise,
  pass editor="<your favorite editor command and arguments>".

  Example:

  $ rake post editor="gvim -f"
end_desc
task :post do
  banner "New post. Type all attributes for new post."
  path = Postview::Settings.load.directory_for(:drafts)
  post = Postage::Post.new(
    :title        => prompt("Post title"),
    :publish_date => prompt("Publish date", Date.today),
    :tags         => prompt("Tags separated by spaces").split(' '),
    :filter       => :markdown,
    :content      => <<-end_content.gsub(/^[ ]{6}/,'')
      Tanks for use #{Postview}.
      Input here the content of your post.
    end_content
  )

  post.build_file
  post.create_into(path)

  printf "%s\n", "The post '#{post.title}' was created in '#{path}/#{post.file}'."

  editor = ENV['editor'] || ENV['EDITOR'] || ENV['VISUAL'] || 'none'
  if prompt("Edit post using '#{editor}'?", "y") =~ /y/i
    if editor
      sh "#{editor} #{path}/#{post.file}"
    else
      printf "%s", "Editor not specified."
    end
  end

end

