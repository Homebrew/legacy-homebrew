require 'requirement'

class PythonDependency < Requirement
  fatal true

  satisfy :build_env => false do
    which python_binary
  end

  def modify_build_environment
    ENV['PYTHONPATH'] = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
  end

  # Deprecated
  def to_s
    python_binary
  end

  protected

  def python_binary
    'python'
  end

  def system_python?
    which(python_binary).to_s == "/usr/bin/python"
  end
end

class Python3Dependency < PythonDependency
  default_formula 'python3'

  protected

  def python_binary
    'python3'
  end

  def system_python?
    false
  end
end
