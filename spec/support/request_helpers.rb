module Request
  module JsonHelpers
    def json_response
      @json_response = JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeaderHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.musicianswanted.v#{version}"
    end

    def api_response_format(format = Mime::JSON)
      request.headers['Accept'] = "#{request.headers['Accept']}, #{format}"
      request.headers['Content-type'] = format.to_s
    end

    def api_mw_token
      request.headers['mw-token'] = ENV["api_access_token"]
    end

    def include_default_accept_headers
      api_header
      api_mw_token
      api_response_format
    end
  end
end
