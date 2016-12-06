require 'formula'

class Abgx360 < Formula
  homepage 'http://abgx360.net/index.php'
  url 'http://static.mouseed.com/src/abgx360/abgx360-1.0.6.tar.gz'
  mirror 'http://dl.dropbox.com/u/59058148/abgx360-1.0.6.tar.gz'
  md5 '04b0c9e0461faa92ca5f8fac78bafe57'

  depends_on 'libidn'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

