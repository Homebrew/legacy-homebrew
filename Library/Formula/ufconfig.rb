require 'formula'

class Ufconfig <Formula
  url 'http://www.cise.ufl.edu/research/sparse/UFconfig/UFconfig-3.5.0.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/UFconfig/'
  md5 '526413bbbc94f987cf79619d9110bab4'
  version '3.5.0'


  def install
    inreplace 'UFconfig.mk' do |s|
      s.change_make_var! "INSTALL_INCLUDE", include
      s.change_make_var! "INSTALL_LIB", lib
      s.change_make_var! "F77", "gfortran"
    end
    inreplace "Makefile", "Lib/libufconfig.a", "libufconfig.a"

    system "mkdir", lib, include
    system "make"
    system "make install"
  end
end
