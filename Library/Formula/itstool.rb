require 'formula'

class Itstool < Formula
  homepage 'http://itstool.org/'
  url 'http://files.itstool.org/itstool/itstool-1.2.0.tar.bz2'
  sha1 'dc6b766c2acec32d3c5d016b0a33e9268d274f63'

  head 'git://gitorious.org/itstool/itstool.git'

  depends_on :autoconf if build.head?
  depends_on :automake if build.head?

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
