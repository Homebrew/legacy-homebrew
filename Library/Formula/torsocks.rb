require 'formula'

class Torsocks < Formula
  homepage 'http://code.google.com/p/torsocks/'
  url 'http://torsocks.googlecode.com/files/torsocks-1.2.tar.gz'
  sha1 'b8afeb217db299892a628e28f2327a1d2697f9ad'

  head 'git://git.torproject.org/git/torsocks.git'

  depends_on 'tor'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
