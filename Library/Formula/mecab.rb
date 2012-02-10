require 'formula'

class Mecab < Formula
  url 'http://mecab.googlecode.com/files/mecab-0.992.tar.gz'
  homepage 'http://mecab.sourceforge.net/'
  sha1 '4b30ee4c352b06ce53457a57d5f0f9d127bccf6c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
