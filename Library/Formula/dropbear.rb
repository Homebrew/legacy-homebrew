require "formula"

class Dropbear < Formula
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/dropbear-2014.65.tar.bz2"
  sha1 "a7b04ff3c27059477ecdd8dccef7d43f644abe46"

  def install
    system "./configure","--prefix=#{prefix}", "--enable-pam", "--enable-zlib"
    system "make"
    system "make", "install"
  end

  test do
      system "dbclient", "-h"
      system "dropbearkey", "-t", "rsa", "-f", "id_rsa"
      assert File.exist?("id_rsa")
  end
end
