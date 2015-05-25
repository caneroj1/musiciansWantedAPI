class API::RouteTableItem
  attr_reader :controller, :format, :verb, :uri, :description

  def initialize(controller, format, verb, uri, description)
    @controller = controller
    @format = format
    @verb = verb
    @uri = uri
    @description = description
  end

  def to_table_row
    row = "<tr><td>#{@controller}</td><td>#{@format}</td>"
    row << "<td>#{@verb}</td><td>#{@uri}</td>"
    row << "<td>#{@description}</td></tr>"
    row
  end
end
