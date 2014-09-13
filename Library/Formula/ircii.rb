require "formula"

class Ircii < Formula
  homepage "http://www.eterna.com.au/ircii/"
  url "http://ircii.warped.com/ircii-20140831.tar.bz2"
  sha1 "a4d3b3a74a418f99217fe572f6e4c358f1ff3139"

  bottle do
    sha1 "c95445429da0b3d45122f84cb597ecc707a42939" => :mavericks
    sha1 "461fa342adc66e1cd7e5d673bfaa9694d7cef766" => :mountain_lion
    sha1 "ba3b54226f16b1dd7ab90ef7f4ee5f0c602eeca5" => :lion
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
