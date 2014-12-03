require "formula"

class Ircii < Formula
  homepage "http://www.eterna.com.au/ircii/"
  url "http://ircii.warped.com/ircii-20141122.tar.bz2"
  sha1 "e243dafb325334240c4306e568fb94fb21b201d6"

  bottle do
  end

  depends_on "openssl"

  def install
    ENV.append "LIBS", "-liconv"
    system "./configure", "--prefix=#{prefix}",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
