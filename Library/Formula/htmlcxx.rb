require 'formula'

class Htmlcxx < Formula
  homepage 'http://htmlcxx.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/htmlcxx/htmlcxx/0.85/htmlcxx-0.85.tar.gz'
  sha1 'e56fef830db51041fd297d269d24379b2dccb928'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
