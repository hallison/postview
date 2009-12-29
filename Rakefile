$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rake/clean'
require 'lib/postview'

# Helpers
# =============================================================================

def rdoc(*args)
  @rdoc ||= if Gem.available? "hanna"
              ["hanna", "--fmt", "html", "--accessor", "option_accessor=RW"]
            else
              ["rdoc"]
            end
  @rdoc += args
  sh @rdoc.join(" ")
end

def test(*args)
  @test ||= (Gem.available? "turn") ? ["turn"] : ["testrb", "-v"]
  @test += args
  sh @test.join(" ")
end

def manifest
  @manifest ||= `git ls-files`.split("\n").sort.reject do |out|
    out =~ /^\./ || out =~ /^doc/
  end.map do |file|
    "    #{file.inspect}"
  end.join(",\n")
end

def history
  @history ||= `git log master --date=short --format='%d;%cd;%s;%b;'`
end

def version
  @version ||= Postview.version
end

def gemspec
  @gemspec ||= Struct.new(:spec, :file).new
  @gemspec.file ||= Pathname.new("postview.gemspec")
  @gemspec.spec ||= eval @gemspec.file.read
  @gemspec
end

# Documentation
# =============================================================================

namespace :doc do

  CLOBBER << FileList["doc/*"]

  file "doc/api/index.html" => FileList["lib/**/*.rb", "README.rdoc", "CHANGELOG"] do |filespec|
    rm_rf "doc"
    rdoc "--op", "doc/api",
         "--charset", "utf8",
         "--main", "'Postview'",
         "--title", "'Postview API Documentation'",
         "--inline-source",
         "--promiscuous",
         "--line-numbers",
         filespec.prerequisites.join(" ")
  end

  desc "Build API documentation (doc/api)"
  task :api => "doc/api/index.html"

  desc "Creates/updates CHANGELOG file."
  task :changelog do |spec|
    File.open("CHANGELOG", "w+") do |changelog|
      history.scan(/(.*?);(.*?);(.*?);(.*?);/m) do |tag, date, subject, content|
        tag.gsub! /[\n\( ].*?:[\) ]|,.*,.*[\)\n ]|[\)\n ]/m, ""
        tag = tag.empty? ? "v0.0.0" : "v#{tag}"
        changelog << "== #{tag} - #{date} - #{subject}\n"
        changelog << "\n#{content}\n"
      end
    end
    puts "Successfully updated CHANGELOG file"
  end

end

# Versioning
# =============================================================================

namespace :version do

  major, minor, patch, build = version.tag.split(".").map{ |key| key.to_i } << 0

  desc "Dump major version"
  task :major do
    version.tag = "#{major+=1}.0.0"
    version.save!
    puts version.to_hash.to_yaml
  end

  desc "Dump minor version"
  task :minor do
    version.tag = "#{major}.#{minor+=1}.0"
    version.save!
    puts version.to_hash.to_yaml
  end

  desc "Dump patch version"
  task :patch do
    version.tag = "#{major}.#{minor}.#{patch+=1}"
    version.save!
    puts version.to_hash.to_yaml
  end

  desc "Dump build version"
  task :build do
    version.tag = "#{major}.#{minor}.#{patch}.#{build+=1}"
    version.save!
    puts version.to_hash.to_yaml
  end

end

task :version => "version:build"

# RubyGems
# =============================================================================

namespace :gem do

  file gemspec.file => FileList["{lib,test}/**", "Rakefile"] do
    spec = gemspec.file.read
    spec.sub! /spec\.version\s*=\s*".*?"/,  "spec.version = #{version.tag.inspect}"
    spec.sub! /spec\.date\s*=\s*".*?"/,     "spec.date = #{version.date.to_s.inspect}"
    spec.sub! /spec\.files\s*=\s*\[.*?\]/m, "spec.files = [\n#{manifest}\n  ]"

    gemspec.file.open("w+") { |file| file << spec }

    puts "Successfully update #{gemspec.file} file"
  end

  desc "Build gem package #{gemspec.spec.file_name}"
  task :build => gemspec.file do
    sh "gem build #{gemspec.file}"
  end

  desc "Deploy gem package to GemCutter.org"
  task :deploy => :build do
    sh "gem push #{gemspec.spec.file_name}"
  end

  desc "Install gem package #{gemspec.spec.file_name}"
  task :install => :build do
    sh "gem install #{gemspec.spec.file_name} --local"
  end

  desc "Uninstall gem package #{gemspec.spec.file_name}"
  task :uninstall do
    sh "gem uninstall #{gemspec.spec.name} --version #{gemspec.spec.version}"
  end

end

# Test
# =============================================================================

desc "Run tests"
task :test, [:pattern] do |spec, args|
  if args[:pattern]
    test "test/#{args[:pattern]}*_test.rb"
  else
    test "test/*_test.rb"
  end
end

# Default
# =============================================================================

task :default => "test"

