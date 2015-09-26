class Makepp < Formula
  desc "Drop-in replacement for GNU make"
  homepage "http://makepp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/makepp/2.0/makepp-2.0.tgz"
  sha256 "d1b64c6f259ed50dfe0c66abedeb059e5043fc02ca500b2702863d96cdc15a19"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
