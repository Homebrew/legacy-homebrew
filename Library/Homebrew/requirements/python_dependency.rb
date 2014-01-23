require 'requirement'

class PythonDependency < Requirement
  fatal true

  satisfy :build_env => false do
    which 'python'
  end

  def modify_build_environment
    ENV['PYTHONPATH'] = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages"
  end

  # Deprecated
  def to_s
    'python'
  end
end

class Python3Dependency < PythonDependency
  default_formula 'python3'

  satisfy :build_env => false do
    which 'python3'
  end
end
