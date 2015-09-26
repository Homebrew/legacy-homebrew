class Pcal < Formula
  desc "Generate Postscript calendars without X"
  homepage "http://pcal.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pcal/pcal/pcal-4.11.0/pcal-4.11.0.tgz"
  sha256 "8406190e7912082719262b71b63ee31a98face49aa52297db96cc0c970f8d207"

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
