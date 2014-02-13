require 'requirement'

class PythonDependency < Requirement
  fatal true

  satisfy :build_env => false do
    which_python
  end

  def which_python
    @which_python ||= if brewed_python?
      Formula.factory(python_binary).bin/python_binary
    else
      which python_binary
    end
  end

  def modify_build_environment
    if !brewed_python? && python_binary == "python"
      ENV['PYTHONPATH'] = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
    end

    ENV.prepend_path "PATH", which_python.dirname if which_python
  end

  def brewed_python?
    Formula.factory(python_binary).installed?
  end

  def system_python?
    which_python.to_s == "/usr/bin/#{python_binary}"
  end

  def python_binary
    'python'
  end

  # Deprecated
  alias_method :to_s, :python_binary
end

class Python3Dependency < PythonDependency
  default_formula 'python3'

  satisfy :build_env => false do
    which_python
  end

  def python_binary
    'python3'
  end
end
