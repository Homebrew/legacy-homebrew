require 'formula'

class Gforth < Formula
  homepage 'http://bernd-paysan.de/gforth.html'
  url 'http://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.0.tar.gz'
  sha1 '5bb357268cba683f2a8c63d2a4bcab8f41cb0086'
  
  depends_on 'libtool'
  depends_on 'libffi'
  depends_on 'pcre'

  def install
    ENV.j1 # Parallel builds won't work

    ENV['CC'] = "gcc-4.2 -arch x86_64"
    system "./configure","--build=x86_64-apple-darwin11", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # Separate build steps.
    system "make install"
  end
end
