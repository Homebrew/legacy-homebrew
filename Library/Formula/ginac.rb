require 'formula'

class Ginac < Formula
  homepage 'http://www.ginac.de/'
  url 'http://www.ginac.de/ginac-1.6.2.tar.bz2'
  sha1 'c93913c4c543874b2ade4f0390030641be7e0c41'

  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
