desc "Creates/updates history file."
task :history, [:branch] do |spec, args|
  File.open("#{spec.name.upcase}.new", "w+") do |history|
    history << `git log #{args[:branch] || :master} --date=short --format="== %ci%n%n=== %s%n%n%b"`
  end
end

