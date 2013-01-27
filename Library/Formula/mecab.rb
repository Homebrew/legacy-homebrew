require 'formula'

class Mecab < Formula
  homepage 'http://mecab.sourceforge.net/'
  url 'http://mecab.googlecode.com/files/mecab-0.995.tar.gz'
  sha1 'fbfe15171d0976cf58c5bcc882b3a00df2117708'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
