module Postview

Application.class_eval do
  set :environment, :production
end

module CLI

# Copying (c) 2009 Hallison Batista
class ServerCommand #:nodoc: all

  include Command

  def initialize(path, arguments)
    @path, @arguments, @options = path, arguments, {}
    @server_options = {}
  end

  def run
    parse_arguments
    load_server
    start_server
  end

  def self.run(args)
    if args.first =~ /^\w.*|^\/\w.*/
      new(args.shift, args.options).run
    else
      new(".", args.options).run
    end
  end

private

  # Options for arguments.
  def options_for(name)
    { :help   => [ nil, "--help", nil,
                   "Show this message." ],
      :host   => [ "-h", "--host [HOST]", String,
                   "Listen on host (default 0.0.0.0)." ],
      :port   => [ "-p", "--port [PORT]", String,
                   "Use port (default: 9000)." ]
    }[name]
  end

  def parse_arguments
    @arguments.summary_indent = "  "
    @arguments.summary_width  = 24
    @arguments.banner = <<-end_banner.gsub(/^[ ]{6}/, '')
      #{Postview::Version}

      Usage:
        #{Postview.name.downcase} server <path> [options]

    end_banner

    @arguments.separator "Server options:"

    @arguments.on(*options_for(:help))   { puts @arguments; exit 0 }
    @arguments.on(*options_for(:host))   { |host| @options[:Host] = host   }
    @arguments.on(*options_for(:port))   { |port| @options[:Port] = port   }

    @arguments.separator ""

    begin
      @arguments.parse!
    rescue => error
      puts error
      puts @arguments
    end
    puts "#{Postview::Version}\n\n"
  end

  def load_server
    # This code extracted from Rack binary.
    start "Loading server" do
      step { @server ||= "mongrel" }
      step { @options[:Host] ||= "0.0.0.0" }
      step { @options[:Port] ||= "9000" }
      step { @path = Pathname.new(@path) }
      step { @config = @path.join("config.ru") }
      step do
        unless @config.exist?
          raise "Configuration #{@config} not found"
        else
          true
        end
      end
      step { @source = @config.read }
      step { @source = @source.gsub(/^require[ ]'postview'/,'') }
      step { @server = Rack::Handler::WEBrick }
    end
  end

  # TODO: Improve this method for run server using production environment.
  def start_server
    init "Postview starting #{@server} on #{@options[:Host]}:#{@options[:Port]}" do
      ENV['RACK_ENV'] = "production"
      config = @config.to_s
      @postview = eval("Rack::Builder.new{(\n#{@source}\n)}.to_app", nil, config)
      @application = Rack::Builder.new do |application|
        use Rack::CommonLogger, STDOUT
        use Rack::ShowExceptions
        run application
      end.to_app
    end
    @server.run(@postview, @options)
  end

end # class ServerCommand

end # module CLI

end # module Postview

