require 'formula'

class Cgvg < Formula
  homepage 'http://www.uzix.org/cgvg.html'
  url 'http://www.uzix.org/cgvg/cgvg-1.6.3.tar.gz'
  sha1 'd5a108e470b6e7bdf7863c540aaf0efc9ddf1335'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
