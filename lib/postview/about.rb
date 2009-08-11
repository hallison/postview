module Postview

# Copyright (c) Hallison Batista
module About #:nodoc: all

  class << self

    def info
      @about ||= OpenStruct.new(YAML.load_file(File.join(ROOT, "INFO")))
    end

    def to_s
      <<-end_info.gsub(/      /,'')
      #{Version}

      Copyright (c) #{Version.info.timestamp.year} #{info.authors.join(', ')}

      #{info.description}
 
      For more information, please see the project homepage <#{info.homepage}>.
      Bugs, enhancements and improvements, please send message to <#{info.email}>.
      end_info
    end

    def to_html
      Maruku.new(to_s).to_html
    end

  end

end # module About

end # module Postview

