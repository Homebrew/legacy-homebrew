require 'formula'

class Qrupdate < Formula
  homepage 'http://sourceforge.net/projects/qrupdate/'
  url 'https://downloads.sourceforge.net/qrupdate/qrupdate-1.1.2.tar.gz'
  sha1 'f7403b646ace20f4a2b080b4933a1e9152fac526'

  depends_on :fortran
  depends_on "homebrew/science/openblas" => :optional

  def install
    ENV.j1
    ENV['PREFIX'] = prefix
    if build.with? 'openblas'
      fflags = ENV.fcflags
      lflags = "#{ENV.ldflags} -L#{Formula["openblas"].lib} -lopenblas"
    else
      # We're using the -ff2c flag here to avoid having to depend on dotwrp.
      # Because qrupdate exports only subroutines, the resulting library is
      # compatible with packages compiled with or without the -ff2c flag.
      fflags = "#{ENV.fcflags} -ff2c"
      lflags = "#{ENV.ldflags} -framework Accelerate"
    end
    inreplace 'Makeconf' do |s|
      s.change_make_var! 'FC', ENV.fc
      s.change_make_var! 'FFLAGS', fflags
      s.change_make_var! 'BLAS',   lflags
      s.change_make_var! 'LAPACK', ""
    end
    cd "./src"
    inreplace 'Makefile' do |s|
      s.gsub! 'install -D', 'install'
    end
    lib.mkpath
    system 'make install'
  end
end
