require "utils.rb"

module Language
  module Python
    def self.major_minor_version python
      version = /\d\.\d/.match `#{python} --version 2>&1`
      return unless version
      Version.new(version.to_s)
    end

    def self.each_python build, &block
      original_pythonpath = ENV["PYTHONPATH"]
      ["python", "python3"].each do |python|
        next if build.without? python
        version = self.major_minor_version python
        ENV["PYTHONPATH"] = if Formulary.factory(python).installed?
          nil
        else
          "#{HOMEBREW_PREFIX}/lib/python#{version}/site-packages"
        end
        block.call python, version if block
      end
      ENV["PYTHONPATH"] = original_pythonpath
    end
  end
end
