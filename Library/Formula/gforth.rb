require 'formula'

class Gforth < Formula
  url 'http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.0.tar.gz'
  homepage 'http://www.jwdt.com/~paysan/gforth.html'
  sha1 '5bb357268cba683f2a8c63d2a4bcab8f41cb0086'

  def install
    ENV.j1 # Parallel builds won't work
    # Install 32-bit only, even on Snow Leopard. See:
    # http://www.groupsrv.com/computers/about648918.html
    ENV['CC'] = "#{ENV.cc} -m32"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # Separate build steps.
    system "make install"
  end
end
