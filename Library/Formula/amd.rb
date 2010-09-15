require 'formula'

class Ufconfig <Formula
  url 'http://www.cise.ufl.edu/research/sparse/UFconfig/UFconfig-3.5.0.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/UFconfig/'
  md5 '526413bbbc94f987cf79619d9110bab4'
  version '3.5.0'
end

class Amd <Formula
  url 'http://www.cise.ufl.edu/research/sparse/amd/AMD-2.2.1.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/amd/'
  md5 'b3e9679ba20635ac4847f01c01d6e992'
  version '2.2.1'

  def install
    d = Dir.getwd
    Ufconfig.new.brew {
      inreplace 'UFconfig.mk' do |s|
        s.change_make_var! "INSTALL_INCLUDE", include
        s.change_make_var! "INSTALL_LIB", lib
        s.change_make_var! "F77", "gfortran"
      end
      cp_r Dir.getwd, d+"/../"
    }

    system "mkdir", lib, include
    system "make"
    system "make install"
  end
end
