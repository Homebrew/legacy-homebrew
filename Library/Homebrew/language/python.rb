require "utils.rb"

module Language
  module Python
    def self.major_minor_version python
      version = /\d\.\d/.match `#{python} --version 2>&1`
      return unless version
      Version.new(version.to_s)
    end

    def self.homebrew_site_packages(version="2.7")
      HOMEBREW_PREFIX/"lib/python#{version}/site-packages"
    end

    def self.each_python build, &block
      original_pythonpath = ENV["PYTHONPATH"]
      ["python", "python3"].each do |python|
        next if build.without? python
        version = self.major_minor_version python
        ENV["PYTHONPATH"] = if Formulary.factory(python).installed?
          nil
        else
          homebrew_site_packages(version)
        end
        block.call python, version if block
      end
      ENV["PYTHONPATH"] = original_pythonpath
    end

    def self.reads_brewed_pth_files? python
      version = major_minor_version python
      return unless homebrew_site_packages(version).directory?
      probe_file = homebrew_site_packages(version)/"homebrew-pth-probe.pth"
      probe_file.atomic_write("import site; site.homebrew_was_here = True")
      result = quiet_system python, "-c", "import site; assert(site.homebrew_was_here)"
      probe_file.unlink
      result
    end

    def self.user_site_packages python
      Pathname.new(`#{python} -c "import site; print(site.getusersitepackages())"`.chomp)
    end

    def self.in_sys_path? python, path
      script = <<-EOS.undent
        import os, sys
        [os.path.realpath(p) for p in sys.path].index(os.path.realpath("#{path}"))
      EOS
      quiet_system python, "-c", script
    end
  end
end
