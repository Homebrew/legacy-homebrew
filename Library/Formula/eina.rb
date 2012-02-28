require 'formula'

class Eina < Formula
  url 'http://download.enlightenment.org/releases/eina-1.1.0.tar.gz'
  homepage 'http://trac.enlightenment.org/e/wiki/Eina'
  md5 'fedb3814427827c1bb777edea3c86298'
  head 'http://svn.enlightenment.org/svn/e/trunk/eina/', :using => :svn

  depends_on 'pkg-config' => :build

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
