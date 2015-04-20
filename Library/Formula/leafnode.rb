require 'formula'

class Leafnode < Formula
  homepage 'http://sourceforge.net/projects/leafnode/'
  url 'https://downloads.sourceforge.net/project/leafnode/leafnode/1.11.10/leafnode-1.11.10.tar.bz2'
  sha1 'c25a6cc36d9080a882836c2cc6516543a85d7fd7'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
