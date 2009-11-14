desc "Creates/updates history file."
task :changelog do |spec|
  history = `git log master --date=short --format='%d;%cd;%s;%b;'`
  File.open("#{spec.name.upcase}", "w+") do |changelog|
    history.scan(/(.*?);(.*?);(.*?);(.*?);/m) do |tag, date, subject, content|
      tag.gsub! /[\n\( ].*?:[\) ]|,.*,.*[\)\n ]|[\)\n ]/m, ""
      tag = tag.empty? ? "v0.0.0" : "v#{tag}"
      changelog << "== #{tag} - #{date} - #{subject}\n"
      changelog << "\n#{content}\n"
    end
  end
end

