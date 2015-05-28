class API::DescriptionHelpers::Parser
  class << self
    attr_reader :descriptions
    BEGIN_DESCRIPTOR  = "@api_description"
    END_DESCRIPTOR    = "@end_description"

    def parse(item)
      add_lines = false
      @descriptions ||= []
      @description = API::DescriptionHelpers::Description.new
      @lines = []

      File.open(item.path, "r").each_line do |line|
        if line.include?(END_DESCRIPTOR) && add_lines
          add_lines = false
          break_off(item.controller)
        end

        @lines << "#{line.strip}" if add_lines

        add_lines = true if line.include?(BEGIN_DESCRIPTOR)
      end
    end

    def break_off(controller)
      @description.configure(@lines, controller)
      @descriptions << @description
      @description = API::DescriptionHelpers::Description.new
      @lines = []
    end
  end
end
