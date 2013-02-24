require 'formula'

class Paperkey < Formula
  homepage 'http://www.jabberwocky.com/software/paperkey/'
  url 'http://www.jabberwocky.com/software/paperkey/paperkey-1.2.tar.gz'
  sha1 '069bb0bdba28682f9fedcd446ae5d1b7633b9788'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
