module HTTParty
  class Response < HTTParty::BasicObject #:nodoc:
    class Headers
      include ::Net::HTTPHeader

      def initialize(header)
        @header = header
      end

      def ==(other)
        @header == other
      end

      def inspect
        @header.inspect
      end

      def method_missing(name, *args, &block)
        if @header.respond_to?(name)
          @header.send(name, *args, &block)
        else
          super
        end
      end

      def respond_to?(method)
        super || @header.respond_to?(method)
      end
    end


    def self.underscore(string)
      string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z])([A-Z])/,'\1_\2').downcase
    end

    attr_reader :request, :response, :parsed_response, :body, :headers

    def initialize(request, response, parsed_response)
      @request = request
      @response = response
      @body = response.body
      @parsed_response = parsed_response
      @headers = Headers.new(response.to_hash)
    end

    def class
      Response
    end

    def code
      response.code.to_i
    end

    def inspect
      inspect_id = "%x" % (object_id * 2)
      %(#<#{self.class}:0x#{inspect_id} @parsed_response=#{parsed_response.inspect}, @response=#{response.inspect}, @headers=#{headers.inspect}>)
    end

    CODES_TO_OBJ = ::Net::HTTPResponse::CODE_CLASS_TO_OBJ.merge ::Net::HTTPResponse::CODE_TO_OBJ

    CODES_TO_OBJ.each do |response_code, klass|
      name = klass.name.sub("Net::HTTP", '')
      define_method("#{underscore(name)}?") do
        klass === response
      end
    end
    
    def respond_to?(name)
      return true if [:request,:response,:parsed_response,:body,:headers].include?(name)
      parsed_response.respond_to?(name) or response.respond_to?(name)
    end

    protected

    def method_missing(name, *args, &block)
      if parsed_response.respond_to?(name)
        parsed_response.send(name, *args, &block)
      elsif response.respond_to?(name)
        response.send(name, *args, &block)
      else
        super
      end
    end
  end
end
