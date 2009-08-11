require 'parsedate'
require 'ostruct'

def default_version
  { :major => 0,
    :minor => 1,
    :patch => 0,
    :release => nil,
    :date => Date.today,
    :timestamp => DateTime.now,
    :cycle => "Development version - Pre-alpha" }
end

def load_version(file = "VERSION")
  File.exist?(file) ? YAML.load_file(file) : default_version
end

def current_version(file = "VERSION")
  @current_value ||= OpenStruct.new(load_version)
end

namespace :version do
  desc "Generate version for new release and tagging."
  task :new, [:major, :minor, :patch, :release, :date, :cycle, :filename] do |spec, args|
    version_file = args[:filename] || "VERSION"
    current = current_version(version_file)
    date    = Date.new(*ParseDate.parsedate(args.date || current.date.to_s).compact) unless args or current
    newer   = {
      :major   => (args[:major] || current.major).to_i,
      :minor   => (args[:minor] || current.minor).to_i,
      :patch   => (args[:patch] || current.patch).to_i,
      :release => args[:release].to_s.empty? ? nil : args[:release].to_i,
      :date    => date || Date.today,
      :timestamp => current.timestamp || default_version[:timestamp],
      :cycle   => args[:cycle] || current.cycle
    }

    newer.merge(current.marshal_dump) do |key, new_value, current_value|
      new_value || current_value
    end

    File.open(version_file, "w+") do |version|
      version << newer.to_yaml
    end
  end

  desc "Show the current version."
  task :show do
    version = [:major, :minor, :patch, :release].map do |info|
      current_version.send info
    end.compact.join('.')
    $stdout.puts "Version #{version} released at #{current_version.date} (#{current_version.cycle})"
    @version = current_version
  end
end

