require 'formula'

class Julia < Formula
  homepage 'http://www.julialang.org'
  head 'https://github.com/JuliaLang/julia.git'

  depends_on "fftw"
  depends_on "gmp"
  depends_on "llvm"
  depends_on "pcre"
  depends_on "readline"

  def install
    ENV.fortran

    libgfortran = `$FC --print-file-name libgfortran.a`.chomp
    ENV.append 'LDFLAGS', "-L#{File.dirname libgfortran}"

    deps = ['FFTW', 'GMP', 'LLVM', 'PCRE', 'BLAS', 'LAPACK']
    deps.each { |dep| system "sed", "-i.bak", "s/USE_SYSTEM_#{dep}=0/USE_SYSTEM_#{dep}=1/", "Make.inc" }

    system "make", "PREFIX=#{prefix}", "install"
    system "make test"

    bin.install_symlink share/'julia/julia'
    bin.install_symlink share/'julia/julia-release-webserver'
  end
end

