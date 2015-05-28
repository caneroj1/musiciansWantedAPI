class API::RouteTable
  class << self
    attr_accessor :table_items

    def make(routes, descriptions)
      @table_items = []
      @descriptions = descriptions

      routes.each do |route|
        create_table_item(route, find_description(route))
      end
    end

    def html
      table_html = ""
      @table_items.each { |item| table_html << item.to_table_row }
      table_html
    end

    protected
    def create_table_item(route, description)
      @table_items << API::RouteTableItem.new(description.controller,
                                              route.format,
                                              route.method,
                                              route.path,
                                              description.description)
    end

    def find_description(route)
      controller = route.controller.split('/').last

      found_description = @descriptions.select do |description|
        description.controller.eql?(controller) && description.action.eql?(route.action)
      end.first

      @descriptions.delete(found_description)
      found_description || API::DescriptionHelpers::Description.new("No route description.", nil, controller)
    end
  end
end
