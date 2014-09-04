require 'formula'

class Ircii < Formula
  homepage 'http://www.eterna.com.au/ircii/'
  url 'http://ircii.warped.com/ircii-20140831.tar.bz2'
  sha1 'a4d3b3a74a418f99217fe572f6e4c358f1ff3139'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
