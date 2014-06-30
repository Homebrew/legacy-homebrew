require 'formula'

class MecabIpadic < Formula
  homepage 'http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html'
  url 'https://downloads.sourceforge.net/project/mecab/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz'
  sha1 '0d9d021853ba4bb4adfa782ea450e55bfe1a229b'

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
