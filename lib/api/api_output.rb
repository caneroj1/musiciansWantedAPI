class API::ApiOutput
  class << self
    DOCUMENTATION_DESCRIPTOR  = "<!--@api_documentation-->"
    STOP_DESCRIPTOR           = "<!--@end_documentation-->"

    def write(html, path)
      lines = ""
      writing_documentation = false
      File.open(path, "r").each_line do |line|
        if !line.include?(DOCUMENTATION_DESCRIPTOR) && !writing_documentation
          lines << line
        elsif line.include?(DOCUMENTATION_DESCRIPTOR) && !writing_documentation
          lines << line
          writing_documentation = true
        elsif line.include?(STOP_DESCRIPTOR) && writing_documentation
          lines << html << "\n#{STOP_DESCRIPTOR}\n"
          writing_documentation = false
        end
      end.close

      File.open(path, "w") { |f| f.write(lines) }
    end
  end
end
