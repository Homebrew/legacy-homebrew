module Utils
  module Inreplace
    def inreplace paths, before=nil, after=nil
      Array(paths).each do |path|
        f = File.open(path, 'r')
        s = f.read

        if before.nil? && after.nil?
          s.extend(StringInreplaceExtension)
          yield s
        else
          sub = s.gsub!(before, after)
          if sub.nil?
            opoo "inreplace in '#{path}' failed"
            puts "Expected replacement of '#{before}' with '#{after}'"
          end
        end

        f.reopen(path, 'w').write(s)
        f.close
      end
    end
  end
end
