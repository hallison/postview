require 'readline'

desc <<-end
  Create new post in #{Postview::Settings.load.directory_for(:posts)}.
end
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

  if prompt("Edit post?", "y") =~ /y/i
    editor = ENV['EDITOR'] || ENV['VISUAL']
    if editor
      sh "#{editor} #{path}/#{post.file}"
    else
      printf "%s", "Editor not specified."
    end
  end

end

