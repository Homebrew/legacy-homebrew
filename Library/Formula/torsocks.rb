require 'formula'

class Torsocks < Formula
  url 'http://torsocks.googlecode.com/files/torsocks-1.2.tar.gz'
  homepage 'http://code.google.com/p/torsocks/'
  md5 '9bdc8786951e7eec6915433f324f22a4'
  head 'git://git.torproject.org/git/torsocks.git'

  depends_on 'tor'

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
