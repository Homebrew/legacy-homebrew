require 'formula'

class Gforth < Formula
  url 'http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.0.tar.gz'
  homepage 'http://www.jwdt.com/~paysan/gforth.html'
  md5 '2979ae86ede73ce2b3576dae957f4098'

  def install
    ENV.j1 # Parallel builds won't work
    # Install 32-bit only, even on Snow Leopard. See:
    # http://www.groupsrv.com/computers/about648918.html
    ENV['CC'] = "gcc -m32"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # Separate build steps.
    system "make install"
  end
end
