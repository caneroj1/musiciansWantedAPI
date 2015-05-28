class API::DescriptionHelpers::PathItem
  attr_accessor :controller, :actions, :path

  def initialize(controller = nil, path = nil)
    @controller = controller
    @path = path
  end
end
