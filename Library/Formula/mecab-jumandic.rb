require 'formula'

class MecabJumandic < Formula
  homepage 'http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html'
  url 'https://downloads.sourceforge.net/project/mecab/mecab-jumandic/5.1-20070304/mecab-jumandic-5.1-20070304.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmecab%2Ffiles%2Fmecab-jumandic%2F5.1-20070304%2F&ts=1398353933'
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
