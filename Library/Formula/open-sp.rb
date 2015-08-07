class OpenSp < Formula
  desc "SGML parser"
  homepage "http://openjade.sourceforge.net"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  bottle do
    revision 1
    sha1 "4da235a77fd987fd1e2ccd0b2f9af43816037463" => :mavericks
    sha1 "1a271e846c1ec9ed352159a159843224cff233b9" => :mountain_lion
    sha1 "720dfb2778e1b1f0d0abea8c13c7cc6f182dfa07" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-doc-build",
                          "--enable-http",
                          "--enable-default-catalog=#{HOMEBREW_PREFIX}/share/sgml/catalog",
                          "--enable-default-search-path=#{HOMEBREW_PREFIX}/share/sgml"
    system "make", "pkgdatadir=#{share}/sgml/opensp", "install"
  end
end
