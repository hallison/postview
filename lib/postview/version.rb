module Postview

# Copyright (c) 2009 Hallison Batista
module Version #:nodoc: all

  class << self

    def info
      @version ||= OpenStruct.new(YAML.load_file(File.join(ROOT, "VERSION")))
    end

    def tag
      %w{major minor patch release}.map do |tag|
        info.send(tag)
      end.compact.join(".")
    end

    def to_s
      "#{name.sub(/::.*/,'')} v#{tag} (#{info.date.strftime('%B %d, %Y')}, #{info.cycle})"
    end

  end

end # module Version

end # module Postview

