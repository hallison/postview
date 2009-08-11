directory "homepage"

file "homepage/index.html" => FileList["homepage"] do |spec|
  puts spec.name
end

task "homepage:index" do |spec|
  puts spec.name
end

