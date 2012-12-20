require 'formula'

class Itstool < Formula
  homepage 'http://itstool.org/'
  url 'http://files.itstool.org/itstool/itstool-1.2.0.tar.bz2'
  head 'git://gitorious.org/itstool/itstool.git'
  version '1.2.0'
  sha1 'dc6b766c2acec32d3c5d016b0a33e9268d274f63'

  def install
    system "./autogen.sh" if ARGV.build_head?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
