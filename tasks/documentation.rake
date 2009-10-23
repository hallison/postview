begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rdoc'
  require 'rake/rdoctask'
end

desc "Generate RDoc API documentation."
Rake::RDocTask.new("doc:api") do |rdoc|
  rdoc.title    = Postview.name
  rdoc.main     = %q{README.rdoc}
  rdoc.options  = %w{--line-numbers --show-hash}
  rdoc.rdoc_dir = %q{doc/api}
  rdoc.rdoc_files.include %w{
    HISTORY
    LICENSE
    README.rdoc
    lib/**/*.rb
  }
end

