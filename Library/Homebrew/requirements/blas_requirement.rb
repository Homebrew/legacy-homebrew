require "requirement"

class BlasRequirement < Requirement
  fatal true
  default_formula "openblas"

  # This ensures that HOMEBREW_BLAS_CFLAGS and HOMEBREW_BLAS_LDFLAGS
  # are always set. It does _not_ add them to CFLAGS or LDFLAGS; that
  # should happen inside the formula.
  env do
    if @satisfied_result
      ENV["HOMEBREW_BLAS_CFLAGS"] ||= ""
      ENV["HOMEBREW_BLAS_LDFLAGS"] ||= "-lblas -llapack"
    else
      ENV["HOMEBREW_BLAS_CFLAGS"] = "-I#{Formula["openblas"].opt_include}"
      ENV["HOMEBREW_BLAS_LDFLAGS"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    end
  end

  satisfy :build_env => true do
    cflags = ENV["HOMEBREW_BLAS_CFLAGS"] || ""
    ldflags = ENV["HOMEBREW_BLAS_LDFLAGS"] || "-lblas -llapack"
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
        Falling back to brewed openblas. If you prefer to use a system BLAS,
        please set HOMEBREW_BLAS_CFLAGS and HOMEBREW_BLAS_LDFLAGS to correct
        values.
      EOS
    end
    success
  end
end
