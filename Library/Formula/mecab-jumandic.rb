class MecabJumandic < Formula
  desc "See mecab"
  homepage "http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html"
  url "https://downloads.sourceforge.net/project/mecab/mecab-jumandic/5.1-20070304/mecab-jumandic-5.1-20070304.tar.gz"
  sha256 "042614dcc04afc68f1cfa2a32f353dc31b06f0674ebab3bfa8e67472709fe657"

  # Via ./configure --help, valid choices are utf8 (default), euc-jp, sjis
  option "charset=", "Select charset: utf8 (default), euc-jp, or sjis"

  depends_on "mecab"

  def install
    charset = ARGV.value("charset") || "utf8"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
    ]

    system "./configure", *args
    system "make", "install"
  end
end
