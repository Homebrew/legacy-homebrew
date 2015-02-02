require 'formula'

class Ginac < Formula
  homepage 'http://www.ginac.de/'
  url 'http://www.ginac.de/ginac-1.6.3.tar.bz2'
  sha1 '39ebd0035491da84ca3406688c15930faebe5ef1'

  depends_on 'pkg-config' => :build
  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
