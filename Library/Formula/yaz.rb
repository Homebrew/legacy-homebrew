# encoding: UTF-8
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.2.1.tar.gz"
  sha1 "a5cf3e3027019d4a1945b33c89627e12745d31d4"

  bottle do
    cellar :any
    sha1 "9741fc93299b5dc0cea0f48d2d59a1305c04a2cf" => :mavericks
    sha1 "1cbaeb61fcba731b78bd511b04bd0cc541a20470" => :mountain_lion
    sha1 "5c4d69aa6303cb4fe76176371e229a7d42becacd" => :lion
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
    result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
    assert_equal "世界こんにちは！", result
  end
end
