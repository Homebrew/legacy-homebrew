class Psutils < Formula
  desc "Collection of PostScript document handling utilities"
  homepage "http://knackered.org/angus/psutils/"
  url "ftp://ftp.knackered.org/pub/psutils/psutils-p17.tar.gz"
  version "p17"
  sha256 "3853eb79584ba8fbe27a815425b65a9f7f15b258e0d43a05a856bdb75d588ae4"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "def5b3fc8cef9b4c532cc26ae216d1c6b0dae54da5a39acbdb818d53a04bf697" => :el_capitan
    sha256 "8fedc8290fdcbd5cb5f8042cc83e4c10c6c2a29888c2a89f72280d3b5b53946d" => :yosemite
    sha256 "032a98149e12af8c223532b01aa74a2ab57ab3c1b5b6d3f0762d2cd2b51d62ee" => :mavericks
  end

  def install
    # This is required, because the makefile expects that its man folder exists
    man1.mkpath
    system "make", "-f", "Makefile.unix",
                         "PERL=/usr/bin/perl",
                         "BINDIR=#{bin}",
                         "INCLUDEDIR=#{pkgshare}",
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
