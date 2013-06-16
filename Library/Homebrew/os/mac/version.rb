require 'version'

module MacOS
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

    def <=>(other)
      v = SYMBOLS.fetch(other, other.to_s)
      super(Version.new(v))
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
