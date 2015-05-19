require "formula"

class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "http://ircii.warped.com/ircii-20141122.tar.bz2"
  sha1 "e243dafb325334240c4306e568fb94fb21b201d6"

  bottle do
    sha1 "a91d564a3a3241e6684785d0a3a7a256ee319def" => :yosemite
    sha1 "4691d4bbbe491b729af842870773b6d899a95433" => :mavericks
    sha1 "826c088f54ddcf68afabc989c1915beb3ee0265d" => :mountain_lion
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
