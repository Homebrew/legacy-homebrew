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

    def pretty_name
      case @version
      when "10.9" then "Mavericks"
      when "10.8" then "Mountain Lion"
      when "10.7" then "Lion"
      when "10.6" then "Snow Leopard"
      when "10.5" then "Leopard"
      when "10.4" then "Tiger"
      else @version
      end
    end
  end
end
