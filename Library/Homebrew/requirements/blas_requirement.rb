require "requirement"

class BlasRequirement < Requirement
  fatal true
  default_formula "openblas"

  # This ensures that HOMEBREW_BLASLAPACK_NAMES, HOMEBREW_BLASLAPACK_LIB 
  # and HOMEBREW_BLASLAPACK_INC are always set. It does _not_ add them to 
  # CFLAGS or LDFLAGS; that should happen inside the formula.
  env do
    if @satisfied_result
      ENV["HOMEBREW_BLASLAPACK_NAMES"] ||= "blas;lapack"
      ENV["HOMEBREW_BLASLAPACK_LIB"]   ||= ""
      ENV["HOMEBREW_BLASLAPACK_INC"]   ||= ""
    else
      ENV["HOMEBREW_BLASLAPACK_NAMES"]   = "openblas"
      ENV["HOMEBREW_BLASLAPACK_LIB"]     = "#{Formula["openblas"].opt_lib}"
      ENV["HOMEBREW_BLASLAPACK_INC"]     = "#{Formula["openblas"].opt_include}"
    end
  end

  satisfy :build_env => true do
    blas_names = ENV["HOMEBREW_BLASLAPACK_NAMES"] || "blas;lapack"
    blas_lib   = ENV["HOMEBREW_BLASLAPACK_LIB"]   || ""
    blas_inc   = ENV["HOMEBREW_BLASLAPACK_INC"]   || ""
    cflags     = blas_inc != "" ? "-I#{blas_inc}"  : ""
    ldflags    = blas_lib != "" ? "-L#{blas_lib} " : ""
    ldflags   += blas_names.split(";").map { |word| "-l#{word}" }.join(" ")
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
