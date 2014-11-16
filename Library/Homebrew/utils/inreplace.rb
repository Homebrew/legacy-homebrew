module Utils
  class InreplaceError < RuntimeError
    def initialize(errors)
      super errors.inject("inreplace failed\n") { |s, (path, errs)|
        s << "#{path}:\n" << errs.map { |e| "  #{e}\n" }.join
      }
    end
  end

  module Inreplace
    def inreplace paths, before=nil, after=nil
      errors = {}

      Array(paths).each do |path|
        s = File.open(path, "rb", &:read).extend(StringInreplaceExtension)

        if before.nil? && after.nil?
          yield s
        else
          after = after.to_s if Symbol === after
          s.gsub!(before, after)
        end

        errors[path] = s.errors if s.errors.any?

        Pathname(path).atomic_write(s)
      end

      raise InreplaceError.new(errors) if errors.any?
    end
    module_function :inreplace
  end
end
