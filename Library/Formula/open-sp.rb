require 'formula'

class OpenSp < Formula
  homepage 'http://openjade.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz'
  sha1 'b4e903e980f8a8b3887396a24e067bef126e97d5'

  bottle do
    sha1 "3fd6af344acc206b463afc19780aa777bcb844fd" => :mavericks
    sha1 "89129198d238d62c738f6aa4c7d0dd78b32ce2b2" => :mountain_lion
    sha1 "aba980c590c12892d1048b34cf3d8ccc1be17fed" => :lion
  end

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
