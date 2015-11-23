class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "http://ircii.warped.com/ircii-20150903.tar.bz2"
  sha256 "617502e17788d619510f3f5efc1217e6c9d3a55e8227ece591c56981b0901324"

  bottle do
    sha256 "62e2eddce9afdcb017823462fee587f140a195c0b98bfdf328e1a4112331ccdb" => :el_capitan
    sha256 "c55179c8ef451aac157747a8cd17f7d0e90913226c05140e222e72f2339d3907" => :yosemite
    sha256 "64550bbd1cce33f9c63e5b1a68eca19fbae4ff3709ce77b594ce47b57621d710" => :mavericks
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
