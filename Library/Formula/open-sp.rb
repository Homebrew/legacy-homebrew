require 'formula'

class OpenSp < Formula
  homepage 'http://openjade.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz'
  sha1 'b4e903e980f8a8b3887396a24e067bef126e97d5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-doc-build",
                          "--enable-default-catalog=#{HOMEBREW_PREFIX}/share/sgml/catalog",
                          "--enable-default-search-path=#{HOMEBREW_PREFIX}/share/sgml"
    system "make", "pkgdatadir=#{share}/sgml/opensp", "install"
  end
end
