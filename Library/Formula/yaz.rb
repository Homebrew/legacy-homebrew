# -*- coding: UTF-8 -*-
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.1.1.tar.gz"
  sha1 "c2ba83d7488278d214fd31a5cbac188d947a800e"

  bottle do
    cellar :any
    sha1 "1045b83e175a62d5590d2a4268f17baa69c63c1c" => :mavericks
    sha1 "378e0566d8193d58fd6a5cec2d4589a9f0f37bfa" => :mountain_lion
    sha1 "187e9601be7a20cd54b23b4d9c17dff2fdfe82b1" => :lion
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
    File.open("marc8.txt", "w") do |f|
      f.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    end

    result = `"#{bin}/yaz-iconv" -f marc8 -t utf8 marc8.txt`.chomp
    assert_equal "世界こんにちは！", result
  end
end
