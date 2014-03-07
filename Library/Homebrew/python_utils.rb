require "utils.rb"

class PythonUtils
  def self.major_minor_version python
    version = /\d\.\d/.match `#{python} --version 2>&1`
    return unless version
    Version.new(version.to_s)
  end

  def self.for_each_python_version build, &block
    pythonpath = ENV["PYTHONPATH"]
    ["python", "python3"].each do |python|
      next if build.without? python
      version = self.major_minor_version python
      ENV["PYTHONPATH"] = unless Formula.factory(python).installed?
        HOMEBREW_PREFIX/"lib/python#{version}/site-packages"
      end
      block.call python, version if block
    end
    ENV["PYTHONPATH"] = pythonpath
  end
end
