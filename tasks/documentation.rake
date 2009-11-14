namespace :rdoc do

  CLOBBER << FileList["doc/*"]

  task :command do
    @rdoccmd = if Gem.available? "hanna"
                 "hanna --fmt html --accessor option_accessor=RW"
               else
                 "rdoc"
               end
  end

  file "doc/api/index.html" => FileList["lib/**/*.rb", "README.*", "CHANGELOG"] do |file_spec|
    rm_rf 'doc'
    sh <<-end_sh.gsub(/[\s\n]+/, ' ').strip
      #{@rdoccmd} --op doc/api
                  --promiscuous
                  --charset utf8
                  --inline-source
                  --line-numbers
                  --main Postview
                  --title 'Postview API Documentation'
                  #{file_spec.prerequisites.join(' ')}
    end_sh
  end

  desc "Build API documentation (doc/api)"
  task :api => [ :command, "doc/api/index.html" ]

end

