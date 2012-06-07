require 'formula'

class Clusterit < Formula
  homepage 'http://www.garbled.net/clusterit.html'
  url 'http://downloads.sourceforge.net/project/clusterit/clusterit/clusterit-2.5/clusterit-2.5.tar.gz'
  md5 'f0e772e07122e388de629fb57f7237ab'

  depends_on :x11

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
