require 'formula'

class Qrupdate < Formula
  url 'http://downloads.sourceforge.net/qrupdate/qrupdate-1.1.1.tar.gz'
  homepage 'http://sourceforge.net/projects/qrupdate/'
  sha1 '8fbaba202b0d4bf80852b2dc6c8d1d4b90b816d4'

  depends_on 'dotwrp'

  def install
    ENV.fortran
    ENV['PREFIX'] = prefix
    inreplace 'Makeconf' do |s|
      # as per the caveats in the gfortran formula:
      s.gsub! /^(FC=).*/, "\\1#{HOMEBREW_PREFIX}/bin/gfortran"
      s.gsub! /^(FFLAGS=).*/, "\\1"+ENV["CFLAGS"]
      s.gsub! /^(BLAS=).*/, "\\1#{ENV["LDFLAGS"]} -ldotwrp -framework Accelerate"
      s.gsub! /^(LAPACK=).*/, "\\1#{ENV["LDFLAGS"]} -ldotwrp -framework Accelerate"
    end
    cd "./src"
    inreplace 'Makefile' do |s|
      s.gsub! 'install -D', 'install'
    end
    mkdir_p lib
    system "make -j 1 install"
  end
end
