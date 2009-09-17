def manifest
  #`git ls-files`.split.sort.reject{ |out| out =~ /^\./ || out =~ /^doc/ }
  %w{HISTORY INFO LICENSE Rakefile README.rdoc VERSION} +
  Dir["{bin,lib,test}/**/**.rb","test/fixtures/**/**","tasks/**/**.rake","themes/**/**"]
end

@gemspec = Gem::Specification.new do |spec|
  spec.executable = 'postview'
  spec.platform = Gem::Platform::RUBY
  spec.version  = Postview::Version.tag
  spec.date     = Postview::Version.info.date

  Postview::About.info.marshal_dump.each do |info, value|
    spec.send("#{info}=", value) if spec.respond_to? "#{info}="
  end

  Postview::About.info.dependencies.each do |name, version|
    spec.add_dependency name, version
  end if Postview::About.info.dependencies

  spec.require_paths = %w[lib]
  spec.files = manifest
  spec.test_files = spec.files.select{ |path| path =~ /^test\/*test\.rb/ }

  spec.has_rdoc = true
  spec.extra_rdoc_files = %w[README.rdoc LICENSE]

  spec.rdoc_options = [
    "--line-numbers",
    "--inline-source",
    "--title", Postview.name,
    "--main", "README"
  ]
  spec.rubyforge_project = spec.name
  spec.rubygems_version = "1.3.3"
  spec.post_install_message = <<-end_message.gsub(/^[ ]{4}/,'')
    #{'-'*78}
    #{Postview::Version}

    Thanks for use this lightweight blogware. Now, you can read your posts by
    editing in your favorite editor.

    Please, feedback in http://github.com/hallison/postview/issues.
    #{'-'*78}
  end_message
end

