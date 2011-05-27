require 'formula'

class SuiteSparse < Formula
  url 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-3.6.0.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/'
  md5 '8ccb9e90b478b5d55b1d9a794e8ed676'

  depends_on "metis"
  depends_on "tbb"

  def install
    # SuiteSparse doesn't like to build in parallel
    ENV.deparallelize

    # So, SuiteSparse was written by a scientific researcher.  This
    # tends to result in makefile-based build systems that are completely
    # ignorant of the existance of things such as CPPFLAGS and LDFLAGS.
    # SuiteSparse Does The Right Thing™ when homebrew is in /usr/local
    # but if it is not, we have to piggyback some stuff in on CFLAGS.
    unless HOMEBREW_PREFIX.to_s == '/usr/local'
      ENV['CFLAGS'] += " -isystem #{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    end

    # Some of the suite-sparse libraries use Metis
    metis = Formula.factory("metis")

    inreplace 'UFconfig/UFconfig.mk' do |s|
      # Compilers
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CPLUSPLUS", ENV.cxx

      # Libraries
      s.change_make_var! "BLAS", "-Wl,-framework -Wl,Accelerate"
      s.change_make_var! "LAPACK", "$(BLAS)"
      s.remove_make_var! "METIS_PATH"
      s.change_make_var! "METIS", metis.lib + 'libmetis.a'
      s.change_make_var! "SPQR_CONFIG", "-DHAVE_TBB"
      s.change_make_var! "TBB", "-ltbb"

      # Installation
      s.change_make_var! "INSTALL_LIB", lib
      s.change_make_var! "INSTALL_INCLUDE", include
    end

    # Remove a stray Lib prefix
    inreplace 'UFconfig/Makefile', %r|Lib/|, ''

    system "make library"

    lib.mkpath
    include.mkpath
    system "make install"
  end
end

