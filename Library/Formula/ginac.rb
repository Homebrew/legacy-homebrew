require 'formula'

class Ginac < Formula
  url 'http://www.ginac.de/ginac-1.6.2.tar.bz2'
  homepage 'http://www.ginac.de/'
  sha1 'c93913c4c543874b2ade4f0390030641be7e0c41'

  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
