require 'formula'

class PltRacket < Formula
  homepage 'http://racket-lang.org/'
  url 'https://github.com/plt/racket/archive/v5.93.tar.gz'
  sha1 '87bbf5f0f2819658b523fa74fbc566627164702b'

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
    This is a minimal Racket distribution.
    If you want to use the DrRacket IDE, we recommend that you use
    the PLT-provided packages from http://racket-lang.org/download/.
    EOS
  end
end
