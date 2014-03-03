require 'requirement'

class PythonDependency < Requirement
  fatal true

  satisfy :build_env => false do
    which_python
  end

  def which_python
    @which_python ||= which python_binary
  end

  def modify_build_environment
    if system_python?
      if python_binary == 'python'
        ENV['PYTHONPATH'] = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
      end
    elsif which_python
      ENV.prepend_path 'PATH', which_python.dirname
    end
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
