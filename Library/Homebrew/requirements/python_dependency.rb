require "language/python"

class PythonDependency < Requirement
  fatal true
  default_formula "python"

  satisfy :build_env => false do
    python = which_python
    next unless python
    version = python_short_version
    next unless version
    # Always use Python 2.7 for consistency on older versions of OSX.
    version == Version.new("2.7")
  end

  def pour_bottle?
    build? || system_python?
  end

  def modify_build_environment
    if system_python?
      if python_binary == "python"
        version = python_short_version
        ENV["PYTHONPATH"] = "#{HOMEBREW_PREFIX}/lib/python#{version}/site-packages"
      end
    elsif which_python
      ENV.prepend_path "PATH", which_python.dirname
    end
  end

  def python_short_version
    @short_version ||= Language::Python.major_minor_version which_python
  end

  def which_python
    python = which python_binary
    return unless python
    executable = `#{python} -c "import sys; print(sys.executable)"`.strip
    return unless executable
    Pathname.new executable
  end

  def system_python; "/usr/bin/#{python_binary}" end
  def system_python?; system_python == which_python.to_s end
  def python_binary; "python" end

  # Deprecated
  alias_method :to_s, :python_binary
end

class Python3Dependency < PythonDependency
  fatal true
  default_formula "python3"

  satisfy(:build_env => false) { which_python }

  def python_binary; "python3" end
end
