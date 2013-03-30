require 'formula'

class SuiteSparse < Formula
  homepage 'http://www.cise.ufl.edu/research/sparse/SuiteSparse'
  url 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-4.1.0.tar.gz'
  sha1 '4f0bd70a87c89ed734558ece724a1bf99616f27b'

  option "without-tbb", "Do not link with tbb (Threading Building Block)"
  option "with-metis", "Compile in metis libraries"
  option "with-openblas", "Use openblas instead of Apple's Accelerate.framework"

  depends_on "tbb" unless build.include? "without-tbb"
  # Metis is optional for now because of
  # cholmod_metis.c:164:21: error: use of undeclared identifier 'idxtype'
  depends_on "metis" if build.include? "with-metis"
  depends_on "homebrew/science/openblas" if build.include? "with-openblas"

  def install
    # SuiteSparse doesn't like to build in parallel
    ENV.j1

    inreplace 'SuiteSparse_config/SuiteSparse_config.mk' do |s|
      if build.include? 'with-openblas'
        s.change_make_var! "BLAS", "-lopenblas"
        s.change_make_var! "LAPACK", "$(BLAS)"
      else
        s.change_make_var! "BLAS", "-Wl,-framework -Wl,Accelerate"
        s.change_make_var! "LAPACK", "$(BLAS)"
      end

      unless build.include? "without-tbb"
        s.change_make_var! "SPQR_CONFIG", "-DHAVE_TBB"
        s.change_make_var! "TBB", "-ltbb"
      end

      if build.include? 'with-metis'
        s.remove_make_var! "METIS_PATH"
        s.change_make_var! "METIS", Formula.factory("metis").lib + "libmetis.a"
      end

      s.change_make_var! "INSTALL_LIB", lib
      s.change_make_var! "INSTALL_INCLUDE", include
    end

    system "make library"

    lib.mkpath
    include.mkpath
    system "make install"
  end
end
