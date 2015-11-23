class Psutils < Formula
  desc "Collection of PostScript document handling utilities"
  homepage "http://knackered.org/angus/psutils/"
  url "ftp://ftp.knackered.org/pub/psutils/psutils-p17.tar.gz"
  version "p17"
  sha256 "3853eb79584ba8fbe27a815425b65a9f7f15b258e0d43a05a856bdb75d588ae4"

  bottle do
    sha256 "44a9141909d2590f8e6b7ffcd48451ad3bce52bcfb7d2bf0f0c5a567c9f1705b" => :yosemite
    sha256 "4be42891f539aa49bdbc1fc75d07defecbd9ca990bf39d5ec7a4a8187fc3efc5" => :mavericks
    sha256 "73d8ddfe85026f715b8f3ade892b4eacca594f48921625b937d6091c32ed6628" => :mountain_lion
  end

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
