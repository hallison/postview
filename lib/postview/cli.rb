module Postview

# Copyright (c) 2009 Hallison Batista
module CLI

  autoload :CreateCommand, 'postview/cli/create_command'
  autoload :ServerCommand, 'postview/cli/server_command'

  # List all commands for CLI options.
  def self.commands
    constants.select do |constant|
      constant =~ /.Command/
    end.map do |constant|
      constant.sub(/Command/,'').downcase
    end.sort
  end

  # Run!
  def self.run(command, args)
    const_get("#{command.capitalize}Command").run(args)
  end

  module Command #:nodoc: all

    # Prompt for values.
    def prompt label, default = nil, regexp = nil
      while true
        message = if default
                    [ "%1$s %2$s [%3$s]: ", " "*2, label, "#{default}" ]
                  else
                    [ "%1$s %2$s: ", " "*2, "#{label}" ]
                  end
        printf *message
        value = $stdin.readline.chomp.strip
        value = default if value.empty?
        if regexp && !value.match(regexp)
          printf "!! Invalid value, please try again."
          value = nil
        end
        return value unless value.nil? || value.to_s.empty?
      end
    end

    def hidden_prompt label
      while true
        system "stty -echo"
        printf "%1$s %2$s: ", " "*2, "#{label}"
        value = $stdin.readline.chomp.strip
        system "stty echo"
        return value unless value.nil? || value.to_s.empty?
      end
    end

    def start process, &block
      printf "%1$s %2$s ", ">"*2, process
      if block_given?
        result = yield
        printf " %s\n", (result ? "done" : "fail")
      end
    rescue Exception => error
      printf " error\n"
      abort format("%1$s %2$s \n", ">"*2, error)
    end

    def init process, &block
      printf "%1$s %2$s ...\n", ">"*2, process
      yield Hash.new
    end

    def step &block
      if block_given?
        result = yield
        printf "%s", (result ? "." : "!")
        result
      end
    end

  end # module Command

end # module CLI

end # module Postview

