require 'pathname'
require 'net/http'
require 'net/https'
require 'uri'
require 'zlib'
# XML backend explicity disabled. Homebrew does not use it so there is no
# reason to vendor the multi_xml gem. However, this may have unintended
# consequences.
#
# FIXME: Check with the HTTParty project to see if commeting this out is safe.
#require 'vendor/multi_xml'
require 'vendor/multi_json'

require 'vendor/httparty/module_inheritable_attributes'
require 'vendor/httparty/cookie_hash'
require 'vendor/httparty/net_digest_auth'
require 'vendor/httparty/version'

# @see HTTParty::ClassMethods
module HTTParty
  module AllowedFormatsDeprecation
    def const_missing(const)
      if const.to_s =~ /AllowedFormats$/
        Kernel.warn("Deprecated: Use HTTParty::Parser::SupportedFormats")
        HTTParty::Parser::SupportedFormats
      else
        super
      end
    end
  end

  extend AllowedFormatsDeprecation

  def self.included(base)
    base.extend ClassMethods
    base.send :include, HTTParty::ModuleInheritableAttributes
    base.send(:mattr_inheritable, :default_options)
    base.send(:mattr_inheritable, :default_cookies)
    base.instance_variable_set("@default_options", {})
    base.instance_variable_set("@default_cookies", CookieHash.new)
  end

  # == Common Request Options
  # Request methods (get, post, put, delete, head, options) all take a common set of options. These are:
  #
  # [:+body+:] Body of the request. If passed a Hash, will try to normalize it first, by default passing it to ActiveSupport::to_params. Any other kind of object will get used as-is.
  # [:+http_proxyaddr+:] Address of proxy server to use.
  # [:+http_proxyport+:]  Port of proxy server to use.
  # [:+limit+:] Maximum number of redirects to follow. Takes precedences over :+no_follow+.
  # [:+query+:] Query string, or a Hash representing it. Normalized according to the same rules as :+body+. If you specify this on a POST, you must use a Hash. See also HTTParty::ClassMethods.default_params.
  # [:+timeout+:] Timeout for opening connection and reading data.
  #
  # There are also another set of options with names corresponding to various class methods. The methods in question are those that let you set a class-wide default, and the options override the defaults on a request-by-request basis. Those options are:
  # * :+base_uri+: see HTTParty::ClassMethods.base_uri.
  # * :+basic_auth+: see HTTParty::ClassMethods.basic_auth. Only one of :+basic_auth+ and :+digest_auth+ can be used at a time; if you try using both, you'll get an ArgumentError.
  # * :+debug_output+: see HTTParty::ClassMethods.debug_output.
  # * :+digest_auth+: see HTTParty::ClassMethods.digest_auth. Only one of :+basic_auth+ and :+digest_auth+ can be used at a time; if you try using both, you'll get an ArgumentError.
  # * :+format+: see HTTParty::ClassMethods.format.
  # * :+headers+: see HTTParty::ClassMethods.headers. Must be a Hash.
  # * :+maintain_method_across_redirects+: see HTTParty::ClassMethods.maintain_method_across_redirects.
  # * :+no_follow+: see HTTParty::ClassMethods.no_follow.
  # * :+parser+: see HTTParty::ClassMethods.parser.
  # * :+pem+: see HTTParty::ClassMethods.pem.
  # * :+query_string_normalizer+: see HTTParty::ClassMethods.query_string_normalizer
  # * :+ssl_ca_file+: see HTTParty::ClassMethods.ssl_ca_file.

  module ClassMethods

    extend AllowedFormatsDeprecation

    # Allows setting http proxy information to be used
    #
    #   class Foo
    #     include HTTParty
    #     http_proxy 'http://foo.com', 80
    #   end
    def http_proxy(addr=nil, port = nil)
      default_options[:http_proxyaddr] = addr
      default_options[:http_proxyport] = port
    end

    # Allows setting a base uri to be used for each request.
    # Will normalize uri to include http, etc.
    #
    #   class Foo
    #     include HTTParty
    #     base_uri 'twitter.com'
    #   end
    def base_uri(uri=nil)
      return default_options[:base_uri] unless uri
      default_options[:base_uri] = HTTParty.normalize_base_uri(uri)
    end

    # Allows setting basic authentication username and password.
    #
    #   class Foo
    #     include HTTParty
    #     basic_auth 'username', 'password'
    #   end
    def basic_auth(u, p)
      default_options[:basic_auth] = {:username => u, :password => p}
    end

    # Allows setting digest authentication username and password.
    #
    #   class Foo
    #     include HTTParty
    #     digest_auth 'username', 'password'
    #   end
    def digest_auth(u, p)
      default_options[:digest_auth] = {:username => u, :password => p}
    end

    # Do not send rails style query strings.
    # Specically, don't use bracket notation when sending an array
    #
    # For a query:
    #   get '/', :query => {:selected_ids => [1,2,3]}
    #
    # The default query string looks like this:
    #   /?selected_ids[]=1&selected_ids[]=2&selected_ids[]=3
    #
    # Call `disable_rails_query_string_format` to transform the query string
    # into:
    #   /?selected_ids=1&selected_ids=2&selected_ids=3
    #
    # @example
    #   class Foo
    #     include HTTParty
    #     disable_rails_query_string_format
    #   end
    def disable_rails_query_string_format
      query_string_normalizer Request::NON_RAILS_QUERY_STRING_NORMALIZER
    end

    # Allows setting default parameters to be appended to each request.
    # Great for api keys and such.
    #
    #   class Foo
    #     include HTTParty
    #     default_params :api_key => 'secret', :another => 'foo'
    #   end
    def default_params(h={})
      raise ArgumentError, 'Default params must be a hash' unless h.is_a?(Hash)
      default_options[:default_params] ||= {}
      default_options[:default_params].merge!(h)
    end

    # Allows setting a default timeout for all HTTP calls
    # Timeout is specified in seconds.
    #
    #   class Foo
    #     include HTTParty
    #     default_timeout 10
    #   end
    def default_timeout(t)
      raise ArgumentError, 'Timeout must be an integer or float' unless t && (t.is_a?(Integer) || t.is_a?(Float))
      default_options[:timeout] = t
    end

    # Set an output stream for debugging, defaults to $stderr.
    # The output stream is passed on to Net::HTTP#set_debug_output.
    #
    #   class Foo
    #     include HTTParty
    #     debug_output $stderr
    #   end
    def debug_output(stream = $stderr)
      default_options[:debug_output] = stream
    end

    # Allows setting HTTP headers to be used for each request.
    #
    #   class Foo
    #     include HTTParty
    #     headers 'Accept' => 'text/html'
    #   end
    def headers(h={})
      raise ArgumentError, 'Headers must be a hash' unless h.is_a?(Hash)
      default_options[:headers] ||= {}
      default_options[:headers].merge!(h)
    end

    def cookies(h={})
      raise ArgumentError, 'Cookies must be a hash' unless h.is_a?(Hash)
      default_cookies.add_cookies(h)
    end

    # Proceed to the location header when an HTTP response dictates a redirect.
    # Redirects are always followed by default.
    #
    # @example
    #   class Foo
    #     include HTTParty
    #     base_uri 'http://google.com'
    #     follow_redirects true
    #   end
    def follow_redirects(value = true)
      default_options[:follow_redirects] = value
    end

    # Allows setting the format with which to parse.
    # Must be one of the allowed formats ie: json, xml
    #
    #   class Foo
    #     include HTTParty
    #     format :json
    #   end
    def format(f = nil)
      if f.nil?
        default_options[:format]
      else
        parser(Parser) if parser.nil?
        default_options[:format] = f
        validate_format
      end
    end

    # Declare whether or not to follow redirects.  When true, an
    # {HTTParty::RedirectionTooDeep} error will raise upon encountering a
    # redirect. You can then gain access to the response object via
    # HTTParty::RedirectionTooDeep#response.
    #
    # @see HTTParty::ResponseError#response
    #
    # @example
    #   class Foo
    #     include HTTParty
    #     base_uri 'http://google.com'
    #     no_follow true
    #   end
    #
    #   begin
    #     Foo.get('/')
    #   rescue HTTParty::RedirectionTooDeep => e
    #     puts e.response.body
    #   end
    def no_follow(value = false)
      default_options[:no_follow] = value
    end

    # Declare that you wish to maintain the chosen HTTP method across redirects.
    # The default behavior is to follow redirects via the GET method.
    # If you wish to maintain the original method, you can set this option to true.
    #
    # @example
    #   class Foo
    #     include HTTParty
    #     base_uri 'http://google.com'
    #     maintain_method_across_redirects true
    #   end

    def maintain_method_across_redirects(value = true)
      default_options[:maintain_method_across_redirects] = value
    end

    # Allows setting a PEM file to be used
    #
    #   class Foo
    #     include HTTParty
    #     pem File.read('/home/user/my.pem'), "optional password"
    #   end
    def pem(pem_contents, password=nil)
      default_options[:pem] = pem_contents
      default_options[:pem_password] = password
    end

    # Override the way query strings are normalized.
    # Helpful for overriding the default rails normalization of Array queries.
    #
    # For a query:
    #   get '/', :query => {:selected_ids => [1,2,3]}
    #
    # The default query string normalizer returns:
    #   /?selected_ids[]=1&selected_ids[]=2&selected_ids[]=3
    #
    # Let's change it to this:
    #  /?selected_ids=1&selected_ids=2&selected_ids=3
    #
    # Pass a Proc to the query normalizer which accepts the yielded query.
    #
    # @example Modifying Array query strings
    #   class ServiceWrapper
    #     include HTTParty
    #
    #     query_string_normalizer proc { |query|
    #       query.map do |key, value|
    #         value.map {|v| "#{key}=#{v}"}
    #       end.join('&')
    #     }
    #   end
    #
    # @param [Proc] normalizer custom query string normalizer.
    # @yield [Hash, String] query string
    # @yieldreturn [Array] an array that will later be joined with '&'
    def query_string_normalizer(normalizer)
      default_options[:query_string_normalizer] = normalizer
    end

    # Allows setting an OpenSSL certificate authority file
    #
    #   class Foo
    #     include HTTParty
    #     ssl_ca_file '/etc/ssl/certs/ca-certificates.crt'
    #   end
    def ssl_ca_file(path)
      default_options[:ssl_ca_file] = path
    end

    # Allows setting an OpenSSL certificate authority path (directory)
    #
    #   class Foo
    #     include HTTParty
    #     ssl_ca_path '/etc/ssl/certs/'
    #   end
    def ssl_ca_path(path)
      default_options[:ssl_ca_path] = path
    end

    # Allows setting a custom parser for the response.
    #
    #   class Foo
    #     include HTTParty
    #     parser Proc.new {|data| ...}
    #   end
    def parser(custom_parser = nil)
      if custom_parser.nil?
        default_options[:parser]
      else
        default_options[:parser] = custom_parser
        validate_format
      end
    end

    # Allows making a get request to a url.
    #
    #   class Foo
    #     include HTTParty
    #   end
    #
    #   # Simple get with full url
    #   Foo.get('http://foo.com/resource.json')
    #
    #   # Simple get with full url and query parameters
    #   # ie: http://foo.com/resource.json?limit=10
    #   Foo.get('http://foo.com/resource.json', :query => {:limit => 10})
    def get(path, options={})
      perform_request Net::HTTP::Get, path, options
    end

    # Allows making a post request to a url.
    #
    #   class Foo
    #     include HTTParty
    #   end
    #
    #   # Simple post with full url and setting the body
    #   Foo.post('http://foo.com/resources', :body => {:bar => 'baz'})
    #
    #   # Simple post with full url using :query option,
    #   # which gets set as form data on the request.
    #   Foo.post('http://foo.com/resources', :query => {:bar => 'baz'})
    def post(path, options={})
      perform_request Net::HTTP::Post, path, options
    end

    # Perform a PUT request to a path
    def put(path, options={})
      perform_request Net::HTTP::Put, path, options
    end

    # Perform a DELETE request to a path
    def delete(path, options={})
      perform_request Net::HTTP::Delete, path, options
    end

    # Perform a HEAD request to a path
    def head(path, options={})
      perform_request Net::HTTP::Head, path, options
    end

    # Perform an OPTIONS request to a path
    def options(path, options={})
      perform_request Net::HTTP::Options, path, options
    end

    def default_options #:nodoc:
      @default_options
    end

    private

      def perform_request(http_method, path, options) #:nodoc:
        options = default_options.dup.merge(options)
        process_cookies(options)
        Request.new(http_method, path, options).perform
      end

      def process_cookies(options) #:nodoc:
        return unless options[:cookies] || default_cookies.any?
        options[:headers] ||= headers.dup
        options[:headers]["cookie"] = cookies.merge(options.delete(:cookies) || {}).to_cookie_string
      end

      def validate_format
        if format && parser.respond_to?(:supports_format?) && !parser.supports_format?(format)
          raise UnsupportedFormat, "'#{format.inspect}' Must be one of: #{parser.supported_formats.map{|f| f.to_s}.sort.join(', ')}"
        end
      end
  end

  def self.normalize_base_uri(url) #:nodoc:
    normalized_url = url.dup
    use_ssl = (normalized_url =~ /^https/) || normalized_url.include?(':443')
    ends_with_slash = normalized_url =~ /\/$/

    normalized_url.chop! if ends_with_slash
    normalized_url.gsub!(/^https?:\/\//i, '')

    "http#{'s' if use_ssl}://#{normalized_url}"
  end

  class Basement #:nodoc:
    include HTTParty
  end

  def self.get(*args)
    Basement.get(*args)
  end

  def self.post(*args)
    Basement.post(*args)
  end

  def self.put(*args)
    Basement.put(*args)
  end

  def self.delete(*args)
    Basement.delete(*args)
  end

  def self.head(*args)
    Basement.head(*args)
  end

  def self.options(*args)
    Basement.options(*args)
  end
end

require 'vendor/httparty/core_extensions'
require 'vendor/httparty/hash_conversions'
require 'vendor/httparty/exceptions'
require 'vendor/httparty/parser'
require 'vendor/httparty/request'
require 'vendor/httparty/response'
