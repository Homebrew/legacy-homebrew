require 'formula'

class Libtecla <Formula
  url 'http://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.1.tar.gz'
  homepage 'http://www.astro.caltech.edu/~mcs/tecla/index.html'
  md5 '1892c8db9fecd38ed686b3ccf72a569b'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
