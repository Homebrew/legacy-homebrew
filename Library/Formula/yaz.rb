# -*- coding: UTF-8 -*-
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.0.23.tar.gz"
  sha1 "96ba708d2ecd979f191b5fc47d8833b4b17ff8ac"

  bottle do
    cellar :any
    sha1 "92aa501708051edb6d451a4fcd8c2a5cf29f72bc" => :mavericks
    sha1 "43755b4e06af9c754efe2fe68d271f1d6d23902c" => :mountain_lion
    sha1 "a477c390a7c6c06c02315bb5acdec78251e4c4f8" => :lion
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
