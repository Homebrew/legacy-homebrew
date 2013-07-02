# This is used in the Formula class when the user calls
# `python`, `python2` or `python3`.

# This method has a dual nature. For one, it takes a &block and sets up
# the ENV such that a Python, as defined in the requirements, is the default.
# If there are multiple `PythonInstalled` requirements, the block is evaluated
# once for each Python. This makes it possible to easily support 2.x and
# 3.x Python bindings without code duplication in formulae.
# If you need to special case stuff, set :allowed_major_versions.
# Second, inside the block, a formula author may call this method to access
# certain convienience methods for the currently selected Python, e.g.
# `python.site_packages`.
# This method should be executed in the context of the formula, so that
# prefix is defined. Note, that this method will set @current_python to be
# able to refer to the current python if a block is executed for 2.x and 3.x.
def python_helper(options={:allowed_major_versions => [2, 3]}, &block)
  if !block_given? and !@current_python.nil?
    # We are already inside of a `python do ... end` block, so just return
    # the current_python or false if the version.major is not allowed.
    if options[:allowed_major_versions].include?(@current_python.version.major)
      return @current_python
    else
      return false
    end
  end

  # Look for PythonInstalled requirements for this formula
  python_reqs = requirements.select{ |r| r.kind_of?(PythonInstalled) }
  if python_reqs.empty?
    raise "If you use python in the formula, you have to add `depends_on :python` (or :python3)!"
  end
  # Now select those that are satisfied and matching the version.major and
  # check that no two python binaries are the same (which could be the case
  # because more than one `depends_on :python => 'module_name' may be present).
  filtered_python_reqs = []
  while !python_reqs.empty?
    py = python_reqs.shift
    # this is ulgy but Ruby 1.8 has no `uniq! { }`
    if !filtered_python_reqs.map{ |fpr| fpr.binary }.include?(py.binary) &&
       py.satisfied? &&
       options[:allowed_major_versions].include?(py.version.major) &&
       self.build.with?(py.name) || !(py.optional? || py.recommended?)
    then
      filtered_python_reqs << py
    end
  end

  # Allow to use an else-branch like so: `if python do ... end; else ... end`
  return false if filtered_python_reqs.empty?

  # Sort by version, so the older 2.x will be used first and if no
  # block_given? then 2.x is preferred because it is returned.
  # Further note, having 3.x last allows us to run `2to3 --write .`
  # which modifies the sources in-place (for some packages that need this).
  filtered_python_reqs.sort_by{ |py| py.version }.map do |py|
    # Now is the time to set the site_packages to the correct value
    py.site_packages = lib/py.xy/'site-packages'
    if !block_given?
      return py
    else
      puts "brew: Python block (#{py.binary})..." if ARGV.verbose? && ARGV.debug?
      # Ensure env changes are only temporary
      begin
        old_env = ENV.to_hash
        # In order to install into the Cellar, the dir must exist and be in the
        # PYTHONPATH. This will be executed in the context of the formula
        # so that lib points to the HOMEBREW_PREFIX/Cellar/<formula>/<version>/lib
        puts "brew: Appending to PYTHONPATH: #{py.site_packages}" if ARGV.verbose?
        mkdir_p py.site_packages
        ENV.append 'PYTHONPATH', py.site_packages, ':'
        ENV['PYTHON'] = py.binary
        ENV.prepend 'CMAKE_INCLUDE_PATH', py.incdir, ':'
        ENV.prepend 'PKG_CONFIG_PATH', py.pkg_config_path, ':' if py.pkg_config_path
        ENV.prepend 'PATH', py.binary.dirname, ':' unless py.from_osx?
        #Note: Don't set LDFLAGS to point to the Python.framework, because
        #      it breaks builds (for example scipy.)

        # Track the state of the currently selected python for this block,
        # so if this python_helper is called again _inside_ the block,
        # we can just return the right python (see `else`-branch a few lines down):
        @current_python = py
        res = instance_eval(&block)
        @current_python = nil
        res
      ensure
        ENV.replace(old_env)
      end
    end
  end
end
