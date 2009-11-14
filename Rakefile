$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'lib/postview'
require 'rake/clean'

Rake::application.options.trace = true

FileList["tasks/**.rake"].each do |task_file|
  load task_file
end

namespace :test do

  task :command do
    @testcmd = (Gem.available? "turn") ? "turn" : "testrb -v"
  end

  desc "Run all tests"
  task :all => :command do
    sh "#{@testcmd} test/*_test.rb"
  end

  desc "Run only test found by pattern"
  task :only, [:pattern] => :command do |spec|
    sh "#{@testcmd} test/#{pattern}*_test.rb"
  end

end

task :default => "test:all"
