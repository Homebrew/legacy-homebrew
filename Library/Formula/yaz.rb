# encoding: UTF-8
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.2.0.tar.gz"
  sha1 "7289c3ee6d6ecaf382a4bc094c49b6b24ac7b4fe"

  bottle do
    cellar :any
    sha1 "4086d6c1d981008be24d8b1f8be859b74cb493a0" => :mavericks
    sha1 "5aabe2f46d17330aada8e4b99f4e456564b939c5" => :mountain_lion
    sha1 "dc69b5d1096ff78149a59a3f59914b8296e7348d" => :lion
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
