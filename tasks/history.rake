desc "Creates/updates history file."
task :history, [:branch] do |spec, args|
  File.open(spec.name.upcase, "w+") do |history|
    history << `git log #{args[:branch] || :master} --format="== %ai - %s%n%n%b"`
  end
end

