require 'rake/gempackagetask'

def gemspec
  load 'postview.gemspec' unless @gemspec
  @gemspec
end

Rake::GemPackageTask.new gemspec do |pkg|
  pkg.need_zip = true
end

