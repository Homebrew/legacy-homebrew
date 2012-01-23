require 'formula'

class Eet < Formula
  url 'http://download.enlightenment.org/releases/eet-1.5.0.tar.gz'
  homepage 'http://trac.enlightenment.org/e/wiki/Eet'
  md5 'f6fd734fbf6a2852abf044a2e1a8cabf'
  head 'http://svn.enlightenment.org/svn/e/trunk/eet/', :using => :svn

  depends_on 'pkg-config' => :build
  depends_on 'eina'
  depends_on 'jpeg'
  depends_on 'lzlib'

  def install
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
