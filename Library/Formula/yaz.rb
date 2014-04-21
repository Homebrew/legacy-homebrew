# -*- coding: UTF-8 -*-
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.1.0.tar.gz"
  sha1 "4dba0475a40077a7abb70266962dfa7c07b4a795"

  bottle do
    cellar :any
    sha1 "c7dd52205b36526863e6d89e60c7cf22cc815312" => :mavericks
    sha1 "7386090ffa9dc4126a93a3342076f68118996484" => :mountain_lion
    sha1 "f1b0b22d6bf34a2abd8ef720e120540f37c48753" => :lion
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
