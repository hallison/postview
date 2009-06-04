module Postview

  class Site

    # Attributes to application.
    attr_reader :title, :subtitle, :author, :email
    attr_reader :find, :find_archived
    attr_accessor :url

    def initialize(settings)
      settings.about.instance_variables_set_to(self)
      @find          = Finder.new(settings.file_names_for(:posts))
      @find_archived = Finder.new(settings.file_names_for(:archive))
    end

  end # class Site

end #module Postview

