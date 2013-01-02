require 'formula'

class Libtecla < Formula
  url 'http://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.1.tar.gz'
  homepage 'http://www.astro.caltech.edu/~mcs/tecla/index.html'
  sha1 '99c82990e7a41050211e4a449e50e20ee511c284'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
