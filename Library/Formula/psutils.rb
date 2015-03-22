class Psutils < Formula
  homepage "http://knackered.org/angus/psutils/"
  url "ftp://ftp.knackered.org/pub/psutils/psutils-p17.tar.gz"
  version "p17"
  sha256 "3853eb79584ba8fbe27a815425b65a9f7f15b258e0d43a05a856bdb75d588ae4"

  def install
    # This is required, because the makefile expects that its man folder exists
    man1.mkpath
    system "make", "-f", "Makefile.unix",
                         "PERL=/usr/bin/perl",
                         "BINDIR=#{bin}",
                         "INCLUDEDIR=#{share}/psutils",
                         "MANDIR=#{man1}",
                         "install"
  end

  test do
    system "sh", "-c", "#{bin}/showchar Palatino B > test.ps"
    system "#{bin}/psmerge", "-omulti.ps", "test.ps", "test.ps",
      "test.ps", "test.ps"
    system "#{bin}/psnup", "-n", "2", "multi.ps", "nup.ps"
    system "#{bin}/psselect", "-p1", "multi.ps", "test2.ps"
  end
end
