begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rdoc'
  require 'rake/rdoctask'
end

desc "Generate RDoc API documentation."
Rake::RDocTask.new("doc") do |doc|
  doc.title    = Postview.name
  doc.main     = %q{README.rdoc}
  doc.options  = %w{--line-numbers --show-hash}
  doc.rdoc_dir = %q{doc}
  doc.rdoc_files.include %w{
    HISTORY
    LICENSE
    README.rdoc
    lib/**/*.rb
  }
end

