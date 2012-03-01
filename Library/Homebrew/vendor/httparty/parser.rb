module HTTParty
  # The default parser used by HTTParty, supports xml, json, html, yaml, and
  # plain text.
  #
  # == Custom Parsers
  #
  # If you'd like to do your own custom parsing, subclassing HTTParty::Parser
  # will make that process much easier. There are a few different ways you can
  # utilize HTTParty::Parser as a superclass.
  #
  # @example Intercept the parsing for all formats
  #   class SimpleParser < HTTParty::Parser
  #     def parse
  #       perform_parsing
  #     end
  #   end
  #
  # @example Add the atom format and parsing method to the default parser
  #   class AtomParsingIncluded < HTTParty::Parser
  #     SupportedFormats.merge!(
  #       {"application/atom+xml" => :atom}
  #     )
  #
  #     def atom
  #       perform_atom_parsing
  #     end
  #   end
  #
  # @example Only support the atom format
  #   class ParseOnlyAtom < HTTParty::Parser
  #     SupportedFormats = {"application/atom+xml" => :atom}
  #
  #     def atom
  #       perform_atom_parsing
  #     end
  #   end
  #
  # @abstract Read the Custom Parsers section for more information.
  class Parser
    SupportedFormats = {
      'text/xml'               => :xml,
      'application/xml'        => :xml,
      'application/json'       => :json,
      'text/json'              => :json,
      'application/javascript' => :json,
      'text/javascript'        => :json,
      'text/html'              => :html,
      'application/x-yaml'     => :yaml,
      'text/yaml'              => :yaml,
      'text/plain'             => :plain
    }

    # The response body of the request
    # @return [String]
    attr_reader :body

    # The intended parsing format for the request
    # @return [Symbol] e.g. :json
    attr_reader :format

    # Instantiate the parser and call {#parse}.
    # @param [String] body the response body
    # @param [Symbol] format the response format
    # @return parsed response
    def self.call(body, format)
      new(body, format).parse
    end

    # @return [Hash] the SupportedFormats hash
    def self.formats
      const_get(:SupportedFormats)
    end

    # @param [String] mimetype response MIME type
    # @return [Symbol]
    # @return [nil] mime type not supported
    def self.format_from_mimetype(mimetype)
      formats[formats.keys.detect {|k| mimetype.include?(k)}]
    end

    # @return [Array<Symbol>] list of supported formats
    def self.supported_formats
      formats.values.uniq
    end

    # @param [Symbol] format e.g. :json, :xml
    # @return [Boolean]
    def self.supports_format?(format)
      supported_formats.include?(format)
    end

    def initialize(body, format)
      @body = body
      @format = format
    end
    private_class_method :new

    # @return [Object] the parsed body
    # @return [nil] when the response body is nil or an empty string
    def parse
      return nil if body.nil? || body.empty?
      if supports_format?
        parse_supported_format
      else
        body
      end
    end

    protected

    def xml
      MultiXml.parse(body)
    end

    def json
      MultiJson.decode(body)
    end

    def yaml
      YAML.load(body)
    end

    def html
      body
    end

    def plain
      body
    end

    def supports_format?
      self.class.supports_format?(format)
    end

    def parse_supported_format
      send(format)
    rescue NoMethodError
      raise NotImplementedError, "#{self.class.name} has not implemented a parsing method for the #{format.inspect} format."
    end
  end
end
