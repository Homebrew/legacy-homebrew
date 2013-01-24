require 'formula'

class Psutils < Formula
  homepage 'http://knackered.org/angus/psutils/'
  url 'ftp://ftp.knackered.org/pub/psutils/psutils-p17.tar.gz'
  version 'p17'
  sha1 '6f1ecb5846cffb644826a02bd9153fe5d6387a9b'

  def install
    man1.mkpath # This is required, because the makefile expects that its man folder exists
    system "make", "-f", "Makefile.unix",
                         "PERL=/usr/bin/perl",
                         "BINDIR=#{bin}",
                         "INCLUDEDIR=#{share}/psutils",
                         "MANDIR=#{man1}",
                         "install"
  end

  test do
    system "sh -c '#{bin}/showchar Palatino B > test.ps'"
    system "#{bin}/psmerge", "-omulti.ps", "test.ps", "test.ps", "test.ps", "test.ps"
    system "#{bin}/psnup", "-n", "2", "multi.ps", "nup.ps"
    system "#{bin}/psselect", "-p1", "multi.ps", "test2.ps"
  end
end
