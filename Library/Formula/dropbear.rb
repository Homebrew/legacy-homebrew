require "formula"

class Dropbear < Formula
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/dropbear-2014.65.tar.bz2"
  sha1 "a7b04ff3c27059477ecdd8dccef7d43f644abe46"

  bottle do
    cellar :any
    sha1 "dae9dacc360506b417401b5ac33beda6648c38b3" => :mavericks
    sha1 "5f932b296fb9764d5d982e63f1196ab220c2aa3f" => :mountain_lion
    sha1 "6cb51ab0dadbe813aacd66251c84507a9c5006d1" => :lion
  end

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
