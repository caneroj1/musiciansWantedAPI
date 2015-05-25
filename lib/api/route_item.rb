class API::RouteItem
  attr_accessor :format, :action, :controller, :path, :method

  def initialize(uri, route)
    defaults = route.defaults
    constraints = route.constraints

    @path = uri
    @format = defaults[:format]
    @action = defaults[:action]
    @controller = defaults[:controller]
    @method = format_method(constraints[:request_method])
  end

  def inspect
    inspect_string = "--- Route ---\n\tpath:#{@path}\n\tformat:#{@format}"
    inspect_string << "\n\taction:#{@action}\n\tcontroller:#{@controller}"
    inspect_string << "\n\tmethod: #{@method}\n"
  end

  def format_method(method)
    method.to_s.gsub(/[^[A-Z]]/, "")
  end
end
