require 'formula'

class Paperkey < Formula
  url 'http://www.jabberwocky.com/software/paperkey/paperkey-1.2.tar.gz'
  homepage 'http://www.jabberwocky.com/software/paperkey/'
  md5 '84af99e3f283337722336571c630da93'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end
