require 'formula'

class Psutils < Formula
  homepage 'http://knackered.org/angus/psutils/'
  url 'ftp://ftp.knackered.org/pub/psutils/psutils-p17.tar.gz'
  sha1 '6f1ecb5846cffb644826a02bd9153fe5d6387a9b'

  def install
    ENV.j1
    man1.mkpath # This is required, because the makefile expects that its man folder exists
    system "make -f Makefile.unix PERL=/usr/bin/perl BINDIR=#{bin} INCLUDEDIR=#{share}/psutils MANDIR=#{man1} install" # if this fails, try separate make/make install steps
  end

  def test
    # Unfortunately, there aren't any tests bundled with psutils,
    #  we just run a few of the core binaries and check the return code
    system "sh -c '#{bin}/psnup -h    || [[ $? -eq 1 ]] && exit 0'"
    system "sh -c '#{bin}/psselect -h || [[ $? -eq 1 ]] && exit 0'"
    system "sh -c '#{bin}/pstops -h   || [[ $? -eq 1 ]] && exit 0'"
  end
end
