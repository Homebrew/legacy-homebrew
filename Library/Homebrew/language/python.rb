require "utils.rb"

module Language
  module Python
    def self.major_minor_version(python)
      version = /\d\.\d/.match `#{python} --version 2>&1`
      return unless version
      Version.new(version.to_s)
    end

    def self.homebrew_site_packages(version = "2.7")
      HOMEBREW_PREFIX/"lib/python#{version}/site-packages"
    end

    def self.each_python(build, &block)
      original_pythonpath = ENV["PYTHONPATH"]
      ["python", "python3"].each do |python|
        next if build.without? python
        version = major_minor_version python
        ENV["PYTHONPATH"] = if Formulary.factory(python).installed?
          nil
        else
          homebrew_site_packages(version)
        end
        block.call python, version if block
      end
      ENV["PYTHONPATH"] = original_pythonpath
    end

    def self.reads_brewed_pth_files?(python)
      version = major_minor_version python
      return unless homebrew_site_packages(version).directory?
      return unless homebrew_site_packages(version).writable_real?
      probe_file = homebrew_site_packages(version)/"homebrew-pth-probe.pth"
      begin
        probe_file.atomic_write("import site; site.homebrew_was_here = True")
        quiet_system python, "-c", "import site; assert(site.homebrew_was_here)"
      ensure
        probe_file.unlink if probe_file.exist?
      end
    end

    def self.user_site_packages(python)
      Pathname.new(`#{python} -c "import site; print(site.getusersitepackages())"`.chomp)
    end

    def self.in_sys_path?(python, path)
      script = <<-EOS.undent
        import os, sys
        [os.path.realpath(p) for p in sys.path].index(os.path.realpath("#{path}"))
      EOS
      quiet_system python, "-c", script
    end

    # deprecated; use system "python", *setup_install_args(prefix) instead
    def self.setup_install(python, prefix, *args)
      opoo <<-EOS.undent
        Language::Python.setup_install is deprecated.
        If you are a formula author, please use
          system "python", *Language::Python.setup_install_args(prefix)
        instead.
      EOS

      # force-import setuptools, which monkey-patches distutils, to make
      # sure that we always call a setuptools setup.py. trick borrowed from pip:
      # https://github.com/pypa/pip/blob/043af83/pip/req/req_install.py#L743-L780
      shim = <<-EOS.undent
        import setuptools, tokenize
        __file__ = 'setup.py'
        exec(compile(getattr(tokenize, 'open', open)(__file__).read()
          .replace('\\r\\n', '\\n'), __file__, 'exec'))
      EOS
      args += %w[--single-version-externally-managed --record=installed.txt]
      args << "--prefix=#{prefix}"
      system python, "-c", shim, "install", *args
    end

    def self.setup_install_args(prefix)
      shim = <<-EOS.undent
        import setuptools, tokenize
        __file__ = 'setup.py'
        exec(compile(getattr(tokenize, 'open', open)(__file__).read()
          .replace('\\r\\n', '\\n'), __file__, 'exec'))
      EOS
      %W[
        -c
        #{shim}
        --no-user-cfg
        install
        --prefix=#{prefix}
        --single-version-externally-managed
        --record=installed.txt
      ]
    end

    def self.package_available?(python, module_name)
      quiet_system python, "-c", "import #{module_name}"
    end
  end
end
