module Postview

  class Site

    # Attributes to application.
    attr_reader   :title, :subtitle, :author, :email
    attr_accessor :url
    attr_accessor :find, :find_archived, :find_drafted

    def initialize(attributes = {})
      attributes.instance_variables_set_to(self)
    end

  end # class Site

end #module Postview

