require "requirement"

class NumpyDependency < Requirement
  fatal true

  def initialize(tags)
    @python = tags.include?("python3") ? "python3" : "python2.7"
    super(tags)
  end

  # Because the :python dependency doesn't affect the :build_env
  # that we see here, use :build_env => false in order to potentially see
  # pythons other than system Python. System Python is boring anyway,
  # since numpy comes with 10.7 and newer.
  satisfy(:build_env => false) do
    quiet_system @python, "-c", "import numpy"
  end

  def message; <<-EOS.undent
    This formula requires numpy. The easiest way to install numpy on OS X
    is with pip, which installs numpy as a precompiled wheel.
    To install numpy, try:
      pip#{3 if @python == "python3"} install numpy
  EOS
  end
end
