class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "http://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.14.11.tar.gz"
  sha256 "216bc0e76e3deb655017bb639e87f2175facfdc060138a550e290c383da2cf7a"

  bottle do
    cellar :any
    sha256 "80a529237a94aed9cb637f1f61252e3fae20ad3d3b9156d1367da96df661cc81" => :el_capitan
    sha256 "73db4d4cacc02c83d1cd2d97381c1f72474a05cc4e2a860cdbc9a8b7c95149e3" => :yosemite
    sha256 "c433e6828a9c6b630eb771be906d5db298d9f6e51e504e0a7acca27882f7e9ea" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "gnutls" => :optional
  depends_on "libgcrypt" if build.with? "gnutls"

  def install
    ENV.universal_binary if build.universal?

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
