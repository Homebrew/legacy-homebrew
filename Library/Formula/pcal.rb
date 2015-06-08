require "formula"

class Pcal < Formula
  desc "Generate Postscript calendars without X"
  homepage "http://pcal.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pcal/pcal/pcal-4.11.0/pcal-4.11.0.tgz"
  sha1 "214bcb4c4b7bc986ae495c96f2ab169233a7f973"

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}",
                              "CATDIR=#{man}/cat1"
  end

  test do
    system "#{bin}/pcal"
  end
end
