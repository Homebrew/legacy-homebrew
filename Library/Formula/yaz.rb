# encoding: UTF-8
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.2.0.tar.gz"
  sha1 "7289c3ee6d6ecaf382a4bc094c49b6b24ac7b4fe"

  bottle do
    cellar :any
    sha1 "a809abcc63012c87fb41979824d534d9736344bf" => :mavericks
    sha1 "45e2980e9c75e969e27823e366672fdf75bc8533" => :mountain_lion
    sha1 "bec01aad7cc060ddc9c21bd8ef856b1e4df06115" => :lion
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
