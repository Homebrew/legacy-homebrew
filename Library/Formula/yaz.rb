class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.14.3.tar.gz"
  sha256 "b7a444deb013ab01d051c3e42c07b083a046d0882286a2162dc83b9519b56a49"

  bottle do
    cellar :any
    sha256 "8ea0ce100e9a38496bef54d610a4b8b8d37dc544112dc441e03a0b914f94511d" => :yosemite
    sha256 "4aca9f0698012ffd241dc518c6a381af6d540ae6bef08955b374578144338cd8" => :mavericks
    sha256 "521854c11c2e306ee287d4d9e96b51fce8857f6e2a801d612e93808b460b3cd0" => :mountain_lion
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
