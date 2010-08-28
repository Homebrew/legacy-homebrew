require 'formula'

class PltRacket <Formula
  # There are source packages but the OSX package is a .dmg and the Unix
  # tarball doesn't have everything needed for building on OSX
  url 'git://github.com/plt/racket.git', :tag => 'v5.0.1'
  homepage 'http://racket-lang.org/'
  version '5.0.1'

  # executables work fine until clean step calls strip on them
  skip_clean 'bin'

  def install
    Dir.chdir 'src' do

      args = [ "--disable-debug", "--disable-dependency-tracking",
              "--enable-xonx",
              "--prefix=#{prefix}" ]

      if snow_leopard_64?
        args += ["--enable-mac64", "--enable-sgc", "--disable-gracket"]
      end

      system "./configure", *args
      system "make"
      system "make install"
    end
  end
end
