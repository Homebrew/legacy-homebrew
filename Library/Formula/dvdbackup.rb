class Dvdbackup < Formula
  desc "Rip DVD's from the command-line"
  homepage "http://dvdbackup.sourceforge.net"
  url "https://downloads.sourceforge.net/dvdbackup/dvdbackup-0.4.2.tar.gz"
  sha256 "0a37c31cc6f2d3c146ec57064bda8a06cf5f2ec90455366cb250506bab964550"

  depends_on "libdvdread"

  def install
    system "./configure", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
