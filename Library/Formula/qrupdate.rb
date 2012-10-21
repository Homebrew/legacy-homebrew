require 'formula'

class Qrupdate < Formula
  homepage 'http://sourceforge.net/projects/qrupdate/'
  url 'http://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz'
  sha1 'f7403b646ace20f4a2b080b4933a1e9152fac526'

  depends_on 'dotwrp'

  def install
    ENV.fortran
    ENV['PREFIX'] = prefix
    inreplace 'Makeconf' do |s|
      # as per the caveats in the gfortran formula:
      s.gsub! /^(FC=).*/,     "\\1#{HOMEBREW_PREFIX}/bin/gfortran"
      s.gsub! /^(FFLAGS=).*/, "\\1#{ENV['FCFLAGS']}"
      s.gsub! /^(BLAS=).*/,   "\\1#{ENV["LDFLAGS"]} -ldotwrp -framework Accelerate"
      s.gsub! /^(LAPACK=).*/, "\\1#{ENV["LDFLAGS"]} -ldotwrp -framework Accelerate"
    end
    cd "./src"
    inreplace 'Makefile' do |s|
      s.gsub! 'install -D', 'install'
    end
    lib.mkpath
    ENV.j1
    system 'make install'
  end
end
