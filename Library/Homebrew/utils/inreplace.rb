module Utils
  module Inreplace
    def inreplace paths, before=nil, after=nil
      Array(paths).each do |path|
        s = File.open(path, "rb", &:read)

        if before.nil? && after.nil?
          yield s.extend(StringInreplaceExtension)
        else
          after = after.to_s if Symbol === after
          unless s.gsub!(before, after)
            message = <<-EOS.undent
              inreplace in '#{path}' failed
              Expected replacement of '#{before}' with '#{after}'
            EOS
            ARGV.homebrew_developer? ? odie(message) : opoo(message)
          end
        end

        Pathname(path).atomic_write(s)
      end
    end
    module_function :inreplace
  end
end
