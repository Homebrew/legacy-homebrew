require "formula"

class Xmlstarlet < Formula
  homepage "http://xmlstar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.6.1/xmlstarlet-1.6.1.tar.gz"
  sha1 "87bb104f546caca71b9540807c5b2738944cb219"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
    bin.install_symlink "xml" => "xmlstarlet"
  end
end
