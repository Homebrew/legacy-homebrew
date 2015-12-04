class OpenSp < Formula
  desc "SGML parser"
  homepage "http://openjade.sourceforge.net"
  url "https://downloads.sourceforge.net/project/openjade/opensp/1.5.2/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  bottle do
    revision 1
    sha256 "7ba3e77bc9e94196db6cfdc8549dca198d58849d2692eb131d8d192341dd9ac2" => :mavericks
    sha256 "10e4817a392f4f44c5f02d87232cb58eac393bf6a8d3b7d945d0c4184a71c2d3" => :mountain_lion
    sha256 "8aaecc5f3ebf3db7c5192651891a382f89c2cc919a2aa8c9713b7c8abb51a97f" => :lion
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
