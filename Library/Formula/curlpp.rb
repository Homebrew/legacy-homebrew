require 'formula'

class Curlpp < Formula
  url 'http://curlpp.googlecode.com/files/curlpp-0.7.3.tar.gz'
  homepage 'http://curlpp.org/'
  md5 'ccc3d30d4b3b5d2cdbed635898c29485'

  depends_on 'boost'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
