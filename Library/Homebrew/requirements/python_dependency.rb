require 'requirement'

# We support Python 2.x and 3.x, either brewed or external.
# This requirement locates the correct CPython binary (no PyPy), provides
# support methods like `site_packages`, and writes our sitecustomize.py file.
# In `dependency_collector.rb`, special `:python` and `:python3` shortcuts are
# defined. You can specify a minimum version of the Python that needs to be
# present, but since not every package is ported to 3.x yet,
# `PythonInstalled("2")` is not satisfied by 3.x.
# In a formula that shall provide support for 2.x and 3.x, the idiom is:
# depends_on :python
# depends_on :python3 => :optional # or :recommended
#
# Todo:
# - Allow further options that choose: universal, framework?, brewed?...
class PythonInstalled < Requirement
  attr_reader :min_version
  attr_reader :if3then3
  attr_reader :imports
  attr_accessor :site_packages
  attr_writer :binary # The python.rb formula needs to set the binary

  fatal true  # you can still make Python optional by `depends_on :python => :optional`

  class PythonVersion < Version
    def major
      tokens[0].to_s.to_i  # Python's major.minor are always ints.
    end
    def minor
      tokens[1].to_s.to_i
    end
  end

  def initialize(default_version="2.6", tags=[])
    tags = [tags].flatten
    # Extract the min_version if given. Default to default_version else
    if /(\d+\.)*\d+/ === tags.first.to_s
      @min_version = PythonVersion.new(tags.shift)
    else
      @min_version = PythonVersion.new(default_version)
    end

    # often used idiom: e.g. sipdir = "share/sip#{python.if3then3}"
    if @min_version.major == 3
      @if3then3 = "3"
    else
      @if3then3 = ""
    end

    # Set name according to the major version.
    # The name is used to generate the options like --without-python3
    @name = "python" + @if3then3

    # Check if any python modules should be importable. We use a hash to store
    # the corresponding name on PyPi "<import_name>" => "<name_on_PyPi>".
    # Example: `depends_on :python => ['enchant' => 'pyenchant']
    @imports = {}
    tags.each do |tag|
      if tag.kind_of? String
        @imports[tag] = tag  # if the module name is the same as the PyPi name
      elsif tag.kind_of? Hash
        @imports.merge!(tag)
      end
    end

    # will be set later by the python_helper, because it needs the
    # formula prefix to set site_packages
    @site_packages = nil

    super tags
  end

  # Note that during `satisfy` we still have the PATH as the user has set.
  # We look for a brewed python or an external Python and store the loc of
  # that binary for later usage. (See Formula#python)
  satisfy :build_env => false do
    @unsatisfied_because = ''
    if binary.nil? || !binary.executable?
      @unsatisfied_because += "No `#{@name}` found in your PATH! Consider to `brew install #{@name}`."
      false
    elsif pypy?
      @unsatisfied_because += "Your #{@name} executable appears to be a PyPy, which is not supported."
      false
    elsif version.major != @min_version.major
      @unsatisfied_because += "No Python #{@min_version.major}.x found in your PATH! --> `brew install #{@name}`?"
      false
    elsif version < @min_version
      @unsatisfied_because += "Python version #{version} is too old (need at least #{@min_version})."
      false
    elsif @min_version.major == 2 && `python -c "import sys; print(sys.version_info[0])"`.strip == "3"
      @unsatisfied_because += "Your `python` points to a Python 3.x. This is not supported."
      false
    else
      @imports.keys.all? do |module_name|
        if not importable? module_name
          @unsatisfied_because += "Unsatisfied dependency: #{module_name}\n"
          @unsatisfied_because += "OS X System's " if from_osx?
          @unsatisfied_because += "Brewed " if brewed?
          @unsatisfied_because += "External " unless brewed? || from_osx?
          @unsatisfied_because += "Python cannot `import #{module_name}`. Install with:\n  "
          @unsatisfied_because += "sudo easy_install pip\n  " unless importable? 'pip'
          @unsatisfied_because += "pip-#{version.major}.#{version.minor} install #{@imports[module_name]}"
          false
        else
          true
        end
      end
    end
  end

  def importable? module_name
    quiet_system(binary, "-c", "import #{module_name}")
  end

  # The full path to the python or python3 executable, depending on `version`.
  def binary
    @binary ||= begin
      if brewed?
        # If the python is brewed we always prefer it!
        # Note, we don't support homebrew/versions/pythonXX.rb, though.
        Formula.factory(@name).opt_prefix/"bin/python#{@min_version.major}"
      else
        # Using the ORIGINAL_PATHS here because in superenv, the user
        # installed external Python is not visible otherwise.
        which(@name, ORIGINAL_PATHS.join(':'))
      end
    end
  end

  # The python prefix (special cased for a brewed python to point into the opt_prefix)
  def prefix
    if brewed?
      # Homebrew since a long while only supports frameworked python
      HOMEBREW_PREFIX/"opt/#{name}/Frameworks/Python.framework/Versions/#{version.major}.#{version.minor}"
    elsif from_osx?
      # Python on OS X has been stripped off its includes (unless you install the CLT), therefore we use the MacOS.sdk.
      Pathname.new("#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/#{version.major}.#{version.minor}")
    else
      # What Python knows about itself
      Pathname.new(`#{binary} -c 'import sys;print(sys.prefix)'`.strip)
    end
  end

  # Get the actual x.y.z version by asking python (or python3 if @min_version>=3)
  def version
    @version ||= PythonVersion.new(`#{binary} -c 'import sys;print(sys.version[:5])'`.strip)
  end

  # python.xy => "python2.7" is often used (and many formulae had this as `which_python`).
  def xy
    "python#{version.major}.#{version.minor}"
  end

  # Homebrew's global site-packages. The local ones (just `site_packages`) are
  # populated by the python_helperg method when the `prefix` of a formula is known.
  def global_site_packages
    HOMEBREW_PREFIX/"lib/#{xy}/site-packages"
  end

  # Dir containing Python.h and others.
  def incdir
    if (from_osx? || brewed?) && framework?
      prefix/"Headers"
    else
      # For all other we use Python's own standard method (works with a non-framework version, too)
      Pathname.new(`#{binary} -c 'from distutils import sysconfig; print(sysconfig.get_python_inc())'`.strip)
    end
  end

  # Dir containing e.g. libpython2.7.dylib
  def libdir
    if brewed? || from_osx?
      if @min_version.major == 3
        prefix/"lib/#{xy}/config-#{version.major}.#{version.minor}m"
      else
        prefix/"lib/#{xy}/config"
      end
    else
      Pathname.new(`#{binary} -c "from distutils import sysconfig; print(sysconfig.get_config_var('LIBPL'))"`.strip)
    end
  end

  # Pkgconfig (pc) files of python
  def pkg_config_path
    if from_osx?
      # No matter if CLT-only or Xcode-only, the pc file is always here on OS X:
      path = Pathname.new("/System/Library/Frameworks/Python.framework/Versions/#{version.major}.#{version.minor}/lib/pkgconfig")
      path if path.exist?
    else
      prefix/"lib/pkgconfig"
    end
  end

  # Is the Python brewed (and linked)?
  def brewed?
    @brewed ||= begin
      require 'formula'
      (Formula.factory(@name).opt_prefix/"bin/#{@name}").executable?
    end
  end

  # Is the python the one from OS X?
  def from_osx?
    @from_osx ||= begin
      p = `#{binary} -c "import sys; print(sys.prefix)"`.strip
      p.start_with?("/System/Library/Frameworks/Python.framework")
    end
  end

  # Is the `python` a PyPy?
  def pypy?
    @pypy ||= !(`#{binary} -c "import sys; print(sys.version)"`.downcase =~ /.*pypy.*/).nil?
  end

  def framework
    # We return the path to Frameworks and not the 'Python.framework', because
    # the latter is (sadly) the same for 2.x and 3.x.
    if prefix.to_s =~ /^(.*\/Frameworks)\/(Python\.framework).*$/
      @framework = $1
    end
  end
  def framework?; not framework.nil? end

  def universal?
    @universal ||= archs_for_command(binary).universal?
  end

  def standard_caveats
    if brewed?
      ""  # empty string, so we can concat this
    else
      <<-EOS.undent
        For non-homebrew #{@name} (#{@min_version.major}.x), you need to amend your PYTHONPATH like so:
          export PYTHONPATH=#{global_site_packages}:$PYTHONPATH
      EOS
    end
  end

  def modify_build_environment
    # Most methods fail if we don't have a binary.
    return false if binary.nil?

    # Write our sitecustomize.py
    file = global_site_packages/"sitecustomize.py"
    ohai "Writing #{file}" if ARGV.verbose? && ARGV.debug?
    [".pyc", ".pyo", ".py"].map{ |f|
      global_site_packages/"sitecustomize#{f}"
    }.each{ |f| f.delete if f.exist? }
    file.write(sitecustomize)

    # For non-system python's we add the opt_prefix/bin of python to the path.
    ENV.prepend 'PATH', binary.dirname, ':' unless from_osx?

    ENV['PYTHONHOME'] = nil  # to avoid fuck-ups.
    ENV['PYTHONPATH'] = if brewed? then nil; else global_site_packages.to_s; end
    ENV.append 'CMAKE_INCLUDE_PATH', incdir, ':'
    ENV.append 'PKG_CONFIG_PATH', pkg_config_path, ':' if pkg_config_path
    # We don't set the -F#{framework} here, because if Python 2.x and 3.x are
    # used, `Python.framework` is ambiguous. However, in the `python do` block
    # we can set LDFLAGS+="-F#{framework}" because only one is temporarily set.

    # Udpate distutils.cfg (later we can remove this, but people still have
    # their old brewed pythons and we have to update it here)
    # Todo: If Jack's formula revisions arrive, we can get rid of this here!
    if brewed?
      require 'formula'
      file = Formula.factory(@name).prefix/"Frameworks/Python.framework/Versions/#{version.major}.#{version.minor}/lib/#{xy}/distutils/distutils.cfg"
      ohai "Writing #{file}" if ARGV.verbose? && ARGV.debug?
      file.delete if file.exist?
      file.write <<-EOF.undent
        [global]
        verbose=1
        [install]
        force=1
        prefix=#{HOMEBREW_PREFIX}
      EOF
    end
    true
  end

  def sitecustomize
    <<-EOF.undent
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python>
      import sys

      if sys.version_info[0] != #{version.major}:
          import os
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python #{version.major}.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')
      else:
          # Only do this for a brewed python:
          if sys.executable.startswith('#{HOMEBREW_PREFIX}'):
              # Remove /System site-packages, and the Cellar site-packages
              # which we moved to lib/pythonX.Y/site-packages. Further, remove
              # HOMEBREW_PREFIX/lib/python because we later addsitedir(...).
              sys.path = [ p for p in sys.path
                           if (not p.startswith('/System') and
                               not p.startswith('#{HOMEBREW_PREFIX}/lib/python') and
                               not (p.startswith('#{HOMEBREW_PREFIX}/Cellar/python') and p.endswith('site-packages'))) ]

              # LINKFORSHARED (and python-config --ldflags) return the
              # full path to the lib (yes, "Python" is actually the lib, not a
              # dir) so that third-party software does not need to add the
              # -F/#{HOMEBREW_PREFIX}/Frameworks switch.
              # Assume Framework style build (default since months in brew)
              try:
                  from _sysconfigdata import build_time_vars
                  build_time_vars['LINKFORSHARED'] = '-u _PyMac_Error #{HOMEBREW_PREFIX}/opt/#{name}/Frameworks/Python.framework/Versions/#{version.major}.#{version.minor}/Python'
              except:
                  pass  # remember: don't print here. Better to fail silently.

              # Set the sys.executable to use the opt_prefix
              sys.executable = '#{HOMEBREW_PREFIX}/opt/#{name}/bin/#{xy}'

          # Tell about homebrew's site-packages location.
          # This is needed for Python to parse *.pth.
          import site
          site.addsitedir('#{HOMEBREW_PREFIX}/lib/#{xy}/site-packages')
    EOF
  end

  def message
    @unsatisfied_because
  end

  def <=> other
    version <=> other.version
  end

  def to_s
    binary.to_s
  end

  # Objects of this class are used to represent dependencies on Python and
  # dependencies on Python modules, so the combination of name + imports is
  # enough to identify them uniquely.
  def eql?(other)
    instance_of?(other.class) && name == other.name && imports == other.imports
  end

  def hash
    [name, *imports].hash
  end
end
