require "requirement"

class BlasRequirement < Requirement
  fatal true
  # on OSX -lblas and -llapack should work OOB.
  # the only case when test should fail is when we
  # need BLAS with single precision or complex with Fortran =>
  # use veclibfort
  default_formula "veclibfort" if OS.mac?
  # On Linux we can always fallback to openblas
  default_formula "openblas"   unless OS.mac?

  def initialize(tags = [])
    # if we are on OSX and need fortran and veclibfort is installed
    # by default try it. Otherwise do standard "blas;lapack"
    if tags.include?(:fortran) && OS.mac? && Formula["veclibfort"].installed?
      @default_names = "veclibfort"
      @default_lib   = "#{Formula["veclibfort"].opt_lib}"
      @default_inc   = "#{Formula["veclibfort"].opt_include}"
    else
      @default_names = "blas;lapack"
      @default_lib   = ""
      @default_inc   = ""
    end
    super(tags)
  end

  # This ensures that HOMEBREW_BLASLAPACK_NAMES, HOMEBREW_BLASLAPACK_LIB 
  # and HOMEBREW_BLASLAPACK_INC are always set. It does _not_ add them to 
  # CFLAGS or LDFLAGS; that should happen inside the formula.
  env do
    if @satisfied_result
      ENV["HOMEBREW_BLASLAPACK_NAMES"] ||= @default_names
      ENV["HOMEBREW_BLASLAPACK_LIB"]   ||= @default_lib
      ENV["HOMEBREW_BLASLAPACK_INC"]   ||= @default_inc
    else
      ENV["HOMEBREW_BLASLAPACK_NAMES"]   = "#{self.class.default_formula}"
      ENV["HOMEBREW_BLASLAPACK_LIB"]     = "#{Formula[self.class.default_formula].opt_lib}"
      ENV["HOMEBREW_BLASLAPACK_INC"]     = "#{Formula[self.class.default_formula].opt_include}"
    end
  end

  def self.ldflags(blas_lib,blas_names)
    res  = blas_lib != "" ? "-L#{blas_lib} " : ""
    res += blas_names.split(";").map { |word| "-l#{word}" }.join(" ")
    return res
  end

  def self.cflags(blas_inc)
    return blas_inc != "" ? "-I#{blas_inc}"  : ""
  end

  def self.full_path(blas_lib,blas_names,separator)
    exten = (OS.mac?) ? "dylib" : "so"
    tmp = blas_lib.chomp("/")
    return blas_names.split(";").map { |word| "#{tmp}/lib#{word}.#{exten}" }.join(separator)
  end

  satisfy :build_env => true do
    blas_names = ENV["HOMEBREW_BLASLAPACK_NAMES"] || @default_names
    blas_lib   = ENV["HOMEBREW_BLASLAPACK_LIB"]   || @default_lib
    blas_inc   = ENV["HOMEBREW_BLASLAPACK_INC"]   || @default_inc
    cflags     = BlasRequirement.cflags(blas_inc)
    ldflags    = BlasRequirement.ldflags(blas_lib,blas_names)
    # MKL BLAS may want to link against libpthread (e.g. pthread_mutex_trylock)
    # and we most likely need basic math (atan2, sin, etc) from libm
    # Adding both won't make much harm:
    ldflags   += " -lpthread -lm"
    success = nil
    Dir.mktmpdir do |tmpdir|
      tmpdir = Pathname.new tmpdir
      (tmpdir/"blastest.c").write <<-EOS.undent
        double cblas_ddot(const int, const double*, const int, const double*, const int);
        int main() {
          double x[] = {1.0, 2.0, 3.0}, y[] = {4.0, 5.0, 6.0};
          cblas_ddot(3, x, 1, y, 1);
          return 0;
        }
      EOS
      success = system "#{ENV["CC"]} #{cflags} #{tmpdir}/blastest.c -o #{tmpdir}/blastest #{ldflags}",
                :err => "/dev/null"
      # test fortran to invoke libveclibfort on OS-X
      if @tags.include?(:fortran)
        (tmpdir/"blastest.f90").write <<-EOS.undent
          program test
          implicit none
          integer, parameter :: dp = kind(1.0d0)
          real(dp), external :: ddot
          real, external :: sdot
          real, dimension(3) :: a,b
          real(dp), dimension(3) :: d,e
          integer :: i
          do i = 1,3
            a(i) = 1.0*i
            b(i) = 3.5*i
            d(i) = 1.0d0*i
            e(i) = 3.5d0*i
          end do
          if (ABS(ddot(3,d,1,e,1)-sdot(3,a,1,b,1))>1E-10) then
            call exit(1)
          endif
          end program test
        EOS
        fortran = which(ENV["FC"] || "gfortran")
        success2 = system "#{fortran} #{cflags} #{tmpdir}/blastest.f90 -o #{tmpdir}/blastest #{ldflags}",
               :err => "/dev/null"
        success3 = system "#{tmpdir}/blastest",
               :err => "/dev/null"
        success = ( success && success2 ) && success3
      end 
    end
    if !success
      opoo "BLAS not configured"
      puts <<-EOS.undent
        Falling back to brewed openblas. If you prefer to use a system BLAS, please set
          HOMEBREW_BLASLAPACK_NAMES (e.g. "mkl_intel_lp64;mkl_sequential;mkl_core")
          HOMEBREW_BLASLAPACK_LIB   (e.g. "${MKLROOT}/lib/intel64")
          HOMEBREW_BLASLAPACK_INC   (e.g. "${MKLROOT}/include")
        to correct values.
      EOS
    end
    success
  end
end
