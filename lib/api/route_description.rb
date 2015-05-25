class API::RouteDescription
  class << self
    attr_accessor :paths

    def make_route_descriptions(list_of_routes)
      @paths = Set.new
      list_of_routes.each { |route| @paths.add(get_controller(route.controller)) }
      @paths.each { |path| parse(path) }
      API::DescriptionHelpers::Parser.descriptions
    end

    protected
    def parse(path)
      API::DescriptionHelpers::Parser.parse(path)
    end

    def get_controller(path)
      name = path.split('/').last
      path = File.join(Rails.root, "app/controllers", path) << "_controller.rb"
      API::DescriptionHelpers::PathItem.new(name, path)
    end
  end
end
