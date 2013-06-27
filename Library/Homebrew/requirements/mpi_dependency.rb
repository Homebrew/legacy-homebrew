require 'requirement'

# There are multiple implementations of MPI-2 available.
# http://www.mpi-forum.org/
# This requirement is used to find an appropriate one.
class MPIDependency < Requirement

  attr_reader :lang_list

  fatal true

  default_formula 'open-mpi'

  env :userpaths

  # This method must accept varargs rather than an array for
  # backwards compatibility with formulae that call it directly.
  def initialize(*tags)
    @non_functional = []
    @unknown_langs = []
    @lang_list = [:cc, :cxx, :f77, :f90] & tags
    tags -= @lang_list
    super(tags)
  end

  def mpi_wrapper_works? compiler
    compiler = which compiler
    return false if compiler.nil? or not compiler.executable?

    # Some wrappers are non-functional and will return a non-zero exit code
    # when invoked for version info.
    #
    # NOTE: A better test may be to do a small test compilation a la autotools.
    quiet_system compiler, '--version'
  end

  satisfy do
    @lang_list.each do |lang|
      case lang
      when :cc, :cxx, :f90, :f77
        compiler = 'mpi' + lang.to_s
        @non_functional << compiler unless mpi_wrapper_works? compiler
      else
        @unknown_langs << lang.to_s
      end
    end
    @unknown_langs.empty? and @non_functional.empty?
  end

  env do
    # Set environment variables to help configure scripts find MPI compilers.
    # Variable names taken from:
    # http://www.gnu.org/software/autoconf-archive/ax_mpi.html
    @lang_list.each do |lang|
      compiler = 'mpi' + lang.to_s
      mpi_path = which compiler

      # Fortran 90 environment var has a different name
      compiler = 'MPIFC' if lang == :f90
      ENV[compiler.upcase] = mpi_path
    end
  end

  def message
    if not @unknown_langs.empty?
      <<-EOS.undent
        There is no MPI compiler wrapper for:
            #{@unknown_langs.join ', '}

        The following values are valid arguments to `MPIDependency.new`:
            :cc, :cxx, :f90, :f77
        EOS
    else
      <<-EOS.undent
        Homebrew could not locate working copies of the following MPI compiler
        wrappers:
            #{@non_functional.join ', '}

        If you have a MPI installation, please ensure the bin directory is on your
        PATH and that all the wrappers are functional. Otherwise, a MPI
        installation can be obtained from homebrew by *picking one* of the
        following formulae:
            open-mpi, mpich2
        EOS
    end
  end
end
