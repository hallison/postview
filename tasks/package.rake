require 'rake/gempackagetask'

def files
  #`git ls-files`.split.sort.reject{ |out| out =~ /^\./ || out =~ /^doc/ }
  @files ||= OpenStruct.new :documents => Dir[*%w{ABOUT HISTORY LICENSE Rakefile VERSION README.rdoc}],
                            :binaries => Dir[*%w{{bin,scripts}/**}],
                            :libraries => Dir[*%w{{lib,tasks}/**/**.rb tasks/**/**.rake}],
                            :tests => Dir[*%w{test/**.rb test/fixtures/**/**}],
                            :resources => Dir[*%w{themes/**/**}]
end

def manifest
  files.documents +
  files.binaries  +
  files.libraries +
  files.tests     +
  files.resources
end

def gemspec
  @gemspec ||= Gem::Specification.new do |spec|

    # Global information
    spec.platform = Gem::Platform::RUBY
    spec.executable = "postview"
    spec.name = Postview.name.downcase
    spec.version = Postview::version_tag
    spec.date = Postview::version_spec.date.to_s
    spec.summary = Postview::about_info.summary
    spec.description = Postview::about_info.description
    spec.authors = Postview::about_info.authors
    spec.email = Postview::about_info.email
    spec.homepage = Postview::about_info.homepage

    # Dependencies
    spec.add_dependency "sinatra", ">= 0.9.1.1"
    spec.add_dependency "sinatra-mapping", ">= 1.0.5"
    spec.add_dependency "postage", ">= 0.1.4.1"

    spec.files = manifest
    spec.require_paths = ["lib"]
    spec.test_files = files.tests
    spec.has_rdoc = true
    spec.extra_rdoc_files = %w{README.rdoc LICENSE}
    spec.rdoc_options = [
      "--line-numbers",
      "--inline-source",
      "--title", Postview::version_summary,
      "--main", "README.rdoc"
    ]
    spec.rubyforge_project = spec.name
    spec.rubygems_version = Gem::VERSION
    spec.post_install_message = <<-end_message.gsub(/^[ ]{6}/,'')
      #{'-'*78}
      #{Postview::version_summary}

      Thanks for use this lightweight blogware. Now, you can read your posts by
      editing in your favorite editor.

      Please, feedback in http://github.com/hallison/postview/issues.
      #{'-'*78}
    end_message
  end
end

def gemspec_file
  @gemspec_file ||= Pathname.new("#{gemspec.name}.gemspec")
end

namespace :gem do

  file gemspec_file.to_s => gemspec.files do
    when_writing "Creating #{gemspec_file}" do
      gemspec_file.open "w+" do |spec|
        spec << gemspec.to_yaml
      end
    end
    puts "Successfully built #{gemspec_file}"
  end

  desc "Build #{gemspec_file}"
  task :spec => [gemspec_file]

end

Rake::GemPackageTask.new gemspec do |pkg|
  pkg.need_zip = true
end

