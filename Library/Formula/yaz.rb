# -*- coding: UTF-8 -*-
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.0.23.tar.gz"
  sha1 "96ba708d2ecd979f191b5fc47d8833b4b17ff8ac"

  bottle do
    cellar :any
    sha1 "d04fbd07fdd744d445bbba3d571cd381ced9c26c" => :mavericks
    sha1 "1a2cdba8837a4443d6e889af6f79d199f4361c13" => :mountain_lion
    sha1 "1a6c0701246ef2c245d8c25cc9625a70c7868868" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make install"
  end

  # This test converts between MARC8, an obscure mostly-obsolete library
  # text encoding supported by yaz-iconv, and UTF8.
  test do
    marc8 = File.open("marc8.txt", "w") do |f|
      f.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    end

    result = `"#{bin}/yaz-iconv" -f marc8 -t utf8 marc8.txt`.chomp
    assert_equal "世界こんにちは！", result
  end
end
