class MecabIpadic < Formula
  desc "IPA dictionary compiled for MeCab"
  homepage "http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html"
  url "https://downloads.sourceforge.net/project/mecab/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz"
  sha256 "b62f527d881c504576baed9c6ef6561554658b175ce6ae0096a60307e49e3523"

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
