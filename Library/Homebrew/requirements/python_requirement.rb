require "language/python"

class PythonRequirement < Requirement
  fatal true
  default_formula "python"
  cask "python"

  satisfy :build_env => false do
    python = which_python
    next unless python
    version = python_short_version
    next unless version
    # Always use Python 2.7 for consistency on older versions of OSX.
    version == Version.new("2.7")
  end

  env do
    short_version = python_short_version

    if !system_python? && short_version == Version.new("2.7")
      ENV.prepend_path "PATH", which_python.dirname
    # Homebrew Python should take precedence over older Pythons in the PATH
    elsif short_version != Version.new("2.7")
      ENV.prepend_path "PATH", Formula["python"].opt_bin
    end

    ENV["PYTHONPATH"] = "#{HOMEBREW_PREFIX}/lib/python#{short_version}/site-packages"
  end

  def python_short_version
    @short_version ||= Language::Python.major_minor_version which_python
  end

  def which_python
    python = which python_binary
    return unless python
    Pathname.new Utils.popen_read(python, "-c", "import sys; print(sys.executable)").strip
  end

  def system_python
    "/usr/bin/#{python_binary}"
  end

  def system_python?
    system_python == which_python.to_s
  end

  def python_binary
    "python"
  end

  # Deprecated
  alias_method :to_s, :python_binary
end

class Python3Requirement < PythonRequirement
  fatal true
  default_formula "python3"
  cask "python3"

  satisfy(:build_env => false) { which_python }

  env do
    ENV["PYTHONPATH"] = "#{HOMEBREW_PREFIX}/lib/python#{python_short_version}/site-packages"
  end

  def python_binary
    "python3"
  end
end
