require 'formula'

class Ircii < Formula
  homepage 'http://www.eterna.com.au/ircii/'
  url 'http://ircii.warped.com/ircii-20131230.tar.bz2'
  sha1 'b59f8fcd344c09b8820f6efbcc74ba9af7e587ce'

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
