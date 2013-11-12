module Utils
  module Inreplace
    def inreplace paths, before=nil, after=nil
      Array(paths).each do |path|
        f = File.open(path, 'rb')
        s = f.read

        if before.nil? && after.nil?
          s.extend(StringInreplaceExtension)
          yield s
        else
          after = after.to_s if Symbol === after
          sub = s.gsub!(before, after)
          if sub.nil?
            message = <<-EOS.undent
              inreplace in '#{path}' failed
              Expected replacement of '#{before}' with '#{after}'
            EOS
            ARGV.homebrew_developer? ? odie(message) : opoo(message)
          end
        end

        f.reopen(path, 'wb').write(s)
        f.close
      end
    end
  end
end
