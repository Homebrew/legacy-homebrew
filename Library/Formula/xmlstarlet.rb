require "formula"

class Xmlstarlet < Formula
  homepage "http://xmlstar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.6.0/xmlstarlet-1.6.0.tar.gz"
  sha1 "30ce6291cebac85a4b36ddabae6cf82c9c4eadf7"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
    bin.install_symlink "xml" => "xmlstarlet"
  end
end
