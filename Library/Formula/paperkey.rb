require 'formula'

class Paperkey < Formula
  url 'http://www.jabberwocky.com/software/paperkey/paperkey-1.2.tar.gz'
  homepage 'http://www.jabberwocky.com/software/paperkey/'
  sha1 '069bb0bdba28682f9fedcd446ae5d1b7633b9788'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make check"
    system "make install"
  end
end
