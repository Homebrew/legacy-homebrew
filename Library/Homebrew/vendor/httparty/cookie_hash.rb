class HTTParty::CookieHash < Hash #:nodoc:
  
  CLIENT_COOKIES = %w{path expires domain path secure HTTPOnly}
  
  def add_cookies(value)
    case value
    when Hash
      merge!(value)
    when String
      value.split('; ').each do |cookie|
        array = cookie.split('=')
        self[array[0].to_sym] = array[1]
      end
    else
      raise "add_cookies only takes a Hash or a String"
    end
  end

  def to_cookie_string
    delete_if { |k, v| CLIENT_COOKIES.include?(k.to_s) }.collect { |k, v| "#{k}=#{v}" }.join("; ")
  end
end
