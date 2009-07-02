module Postview

  class Mapping

    attr_reader   :root
    attr_accessor :locations

    def initialize(locations = {})
      @locations = locations
      root_set_to @locations[:root] || "/"
    end

    def root_set_to(path)
      @root = "/#{path}/".gsub(/[\/]{2,}/,'/')
    end
    alias :root= :root_set_to

    def path(*args)
      !args.empty? ? "/#{@root}/#{args.join('/')}".gsub(/[\/]{2,}/,'/') : @root
    end

    def path_to(*args)
      path(*locations_get_from(*remove_root_key(*args)))
    end

    def path_to_title(path, *args)
      title = (@locations[path] || path).gsub(%r{(#{@root}|[/:])},'')
      title.gsub!(/\W/,' ') # Cleanup
      (args.empty? ? title : "#{title} #{args.join(' ')}").capitalize
    end

  private

    def remove_root_key(*args)
      args.shift if args.first == :root
      args
    end

    def locations_get_from(*args)
      args.collect do |key|
        @locations.has_key?(key) ? @locations[key] : key
      end
    end

  end # class Router

end # module Postview

