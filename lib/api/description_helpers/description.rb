class API::DescriptionHelpers::Description
  attr_accessor :description, :action, :controller
  ACTION_DESCRIPTOR = "@action"

  def initialize(description = nil, action = nil, controller = nil)
    @description = description
    @action = action
    @controller = controller
  end

  def configure(lines, controller)
    @controller = controller
    @description = ""

    lines.each do |line|
      if line.include?(ACTION_DESCRIPTOR)
        add_action(line)
      else
        @description << line.gsub('#', '').strip << "\n"
      end
    end
  end

  protected
  def add_action(line)
    @action = line.gsub('#', '').split('=')[1]
  end
end
