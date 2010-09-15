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
end

class Camd <Formula
  url 'http://www.cise.ufl.edu/research/sparse/camd/CAMD-2.2.1.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/camd/'
  md5 '5cdcc478f544fb672d8f4fade3b5f3a6'
  version '2.2.1'
end

class Ccolamd <Formula
  url 'http://www.cise.ufl.edu/research/sparse/ccolamd/CCOLAMD-2.7.2.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/ccolamd/'
  md5 '79d813d5b54951060fc264172bfb5ca6'
  version "2.7.2"
end

class Colamd <Formula
  url 'http://www.cise.ufl.edu/research/sparse/colamd/COLAMD-2.7.2.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/colamd/'
  md5 '2b4e43c8ef33dacfade6d1ec49542ac1'
  version '2.7.2'
end

class Cholmod <Formula
  url 'http://www.cise.ufl.edu/research/sparse/cholmod/CHOLMOD-1.7.1.tar.gz'
  homepage 'http://www.cise.ufl.edu/research/sparse/cholmod/'
  md5 '9032c5724bee43ccd8f4546338a29fac'
  version '1.7.1'
end

class Metis <Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-4.0.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/metis/metis/overview'
  md5 '0aa546419ff7ef50bd86ce1ec7f727c7'
  version '4.0'
end


class Umfpack <Formula
  url 'http://www.cise.ufl.edu/research/sparse/umfpack/UMFPACK-5.5.0.tar.gz'
  homepage ''
  md5 '19f5d8b4231ec9114718641ce51cce6e'


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

    [Amd, Camd, Ccolamd, Colamd, Cholmod, Metis].each { |c|
      c.new.brew { cp_r Dir.getwd, d+"/../" }
    }

    system "mkdir", lib, include
    system "make"
    system "make install"
  end
end
