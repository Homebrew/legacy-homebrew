require 'formula'

class MecabJumandic < Formula
  desc "See mecab"
  homepage 'http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html'
  url 'https://downloads.sourceforge.net/project/mecab/mecab-jumandic/5.1-20070304/mecab-jumandic-5.1-20070304.tar.gz'
  sha1 '0672cb267b8fde6268a69d57add7ab1544e62154'

  # Via ./configure --help, valid choices are utf8 (default), euc-jp, sjis
  option 'charset=', "Select charset: utf8 (default), euc-jp, or sjis"

  depends_on "mecab"

  def install
    charset = ARGV.value('charset') || 'utf8'
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
    ]

    system "./configure", *args
    system "make install"
  end
end
