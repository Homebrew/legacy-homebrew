require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  url 'https://github.com/plt/racket/archive/v5.92.tar.gz'
  sha1 'e5be589bf8686e002c580405058616d754a1e6d1'

  def install
    cd 'racket/src' do
      args = ["--disable-debug", "--disable-dependency-tracking",
              "--enable-xonx",
              "--prefix=#{prefix}" ]

      args << '--disable-mac64' if not MacOS.prefer_64_bit?

      system "./configure", *args
      system "make"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    We've installed a *minimal* Racket distribution.
    If you want to use the DrRacket IDE, we recommend that you use
    the PLT-provided packages from http://racket-lang.org/download/.
    EOS
  end
end
