require 'formula'

class Clusterit < Formula
  homepage 'http://www.garbled.net/clusterit.html'
  url 'http://downloads.sourceforge.net/project/clusterit/clusterit/clusterit-2.5/clusterit-2.5.tar.gz'
  sha1 '65d36116665179dd16029ac53182fde92d868020'

  depends_on :x11

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
