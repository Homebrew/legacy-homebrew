require 'version'

module MacOS
  class Version < ::Version
    def <=>(other)
      v = case other
          when :mountain_lion then 10.8
          when :lion          then 10.7
          when :snow_leopard  then 10.6
          when :leopard       then 10.5
          when :tiger         then 10.4
          else other.to_s
          end
      super(Version.new(v))
    end

    def pretty_name
      @version.split('_').map(&:capitalize).join(' ')
    end
  end
end
