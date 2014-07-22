# encoding: UTF-8
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.3.0.tar.gz"
  sha1 "e3039feb0afaef761bc3178d66e0d7106e7c9018"

  bottle do
    cellar :any
    sha1 "0a4f9eddc76963d82e4457ccb698ac1d4ba65261" => :mavericks
    sha1 "b4602aa7afa9230e45019503a5976f31c9f3dcfb" => :mountain_lion
    sha1 "b25e669a21b16b9339db851efcdce2f2e853526f" => :lion
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
