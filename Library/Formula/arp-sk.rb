require "formula"

class ArpSk < Formula
  homepage "http://sid.rstack.org/arp-sk/"
  url "http://sid.rstack.org/arp-sk/files/arp-sk-0.0.16.tgz"
  sha1 "c7c0af367640d852f3ff622c5b03096ce4e940a4"

  depends_on "libnet"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libnet=#{Formula['libnet'].opt_prefix}"
    system "make", "install"
  end
end
