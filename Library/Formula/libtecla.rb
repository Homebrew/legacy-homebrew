require 'formula'

class Libtecla < Formula
  homepage 'http://www.astro.caltech.edu/~mcs/tecla/index.html'
  url 'http://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.2.tar.gz'
  sha1 '2eae391d29ee02d921e73c4acc78350c9b03d618'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
