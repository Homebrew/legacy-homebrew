require 'requirement'

class FortranDependency < Requirement
  fatal true

  default_formula 'gfortran'

  env { ENV.fortran }

  satisfy :build_env => false do
    (ENV['FC'] || which('gfortran')) ? true : false
  end

  def message; <<-EOS.undent
    Fortran is required to install.

    You can install this with Homebrew using:
      brew install gfortran

    Or you can use an external compiler by setting:
      FC=<path-to-fortran-compiler>
    EOS
  end
end
