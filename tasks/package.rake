require 'rake/packagetask'

Rake::PackageTask.new Postview.name.downcase, Postview.version do |pkg|
  pkg.need_zip  = true
  pkg.package_files.include(
    "lib/**/*.rb",
    "config/*.*",
    "views/*.erb",
    "public/**/*"
  )
end

