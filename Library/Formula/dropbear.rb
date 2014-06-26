require "formula"

class Dropbear < Formula
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://dropbear.nl/mirror/dropbear-2014.63.tar.bz2"
  sha1 "63bbb967feb1df8bc1a7cb7d96925ed653960078"

  def install
    system "./configure --enable-pam --enable-zlib"
    system "make"
    bin.install "dbclient"
    bin.install "dropbearkey"
    bin.install "dropbearconvert"
  end
    test do
      keyfile = "id_rsa"
      system "dbclient -h"
      system "dropbearkey -t rsa -f keyfile"
      assert File.exist?("keyfile")
    end
end
