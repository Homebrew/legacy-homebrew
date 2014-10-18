# encoding: UTF-8
require "formula"

class Yaz < Formula
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.4.3.tar.gz"
  sha1 "3da21b6f420c0305850e1286c821a1099676e516"

  bottle do
    cellar :any
    sha1 "603137fa06707207b0285a7f2589a4739dcb9149" => :mavericks
    sha1 "f070ca68095aef1b1cac2e502129142768c58da5" => :mountain_lion
    sha1 "e8b4bc41dc99b5fc0912400255ac62b4a8d16665" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "gnutls" => :optional
  depends_on "libgcrypt" if build.with? "gnutls"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make", "install"
  end

  test do
    # This test converts between MARC8, an obscure mostly-obsolete library
    # text encoding supported by yaz-iconv, and UTF8.
    marc8file = testpath/"marc8.txt"
    marc8file.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    result = `#{bin}/yaz-iconv -f marc8 -t utf8 #{marc8file}`
    result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
    assert_equal "世界こんにちは！", result

    # Test ICU support if building with ICU by running yaz-icu
    # with the example icu_chain from its man page.
    if build.with? "icu4c"
      # The input string should be transformed to be:
      # * without control characters (tab)
      # * split into tokens at word boundaries (including -)
      # * without whitespace and Punctuation
      # * xy transformed to z
      # * lowercase
      configurationfile = testpath/"icu-chain.xml"
      configurationfile.write <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <icu_chain locale="en">
          <transform rule="[:Control:] Any-Remove"/>
          <tokenize rule="w"/>
          <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove"/>
          <transliterate rule="xy > z;"/>
          <display/>
          <casemap rule="l"/>
        </icu_chain>
      EOS

      inputfile = testpath/"icu-test.txt"
      inputfile.write "yaz-ICU	xy!"

      expectedresult = <<-EOS.undent
        1 1 'yaz' 'yaz'
        2 1 '' ''
        3 1 'icuz' 'ICUz'
        4 1 '' ''
      EOS

      result = `#{bin}/yaz-icu -c #{configurationfile} #{inputfile}`
      assert_equal expectedresult, result
    end
  end
end
