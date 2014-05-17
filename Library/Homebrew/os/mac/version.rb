require 'version'

module OS
  module Mac
    class Version < ::Version
      SYMBOLS = {
        :mavericks     => '10.9',
        :mountain_lion => '10.8',
        :lion          => '10.7',
        :snow_leopard  => '10.6',
        :leopard       => '10.5',
        :tiger         => '10.4',
      }

      def self.from_symbol(sym)
        new(SYMBOLS.fetch(sym))
      end

      def initialize(*args)
        super
        @comparison_cache = {}
      end

      def <=>(other)
        @comparison_cache.fetch(other) do
          v = SYMBOLS.fetch(other, other.to_s)
          @comparison_cache[other] = super(Version.new(v))
        end
      end

      def to_sym
        case @version
        when '10.9' then :mavericks
        when '10.8' then :mountain_lion
        when '10.7' then :lion
        when '10.6' then :snow_leopard
        when '10.5' then :leopard
        when '10.4' then :tiger
        else :dunno
        end
      end

      def pretty_name
        to_sym.to_s.split('_').map(&:capitalize).join(' ')
      end
    end
  end
end
