require 'requirement'

class FortranDependency < Requirement
  fatal true

  default_formula 'gcc'

  env { ENV.fortran }

  satisfy :build_env => false do
    (ENV['FC'] || which('gfortran')) ? true : false
  end
end
