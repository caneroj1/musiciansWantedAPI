class API::Routes
  class << self
    attr_reader :route_items

    def document(start, path_to_documentation_file)
      list_routes(start)
      descriptions = API::RouteDescription.make_route_descriptions(@route_items)
      API::RouteTable.make(@route_items, descriptions)
      API::ApiOutput.write(API::RouteTable.html, path_to_documentation_file)
    end

    protected
    def list_routes(start)
      @route_items = []

      Rails.application.routes.routes.each do |route|
        uri = route.path.spec.to_s
        if uri.starts_with?(start)
          @route_items << API::RouteItem.new(uri, route)
        end
      end
    end
  end
end
