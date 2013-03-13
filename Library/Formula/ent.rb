require 'formula'

class Ent < Formula
  homepage 'http://www.fourmilab.ch/random/'
  # This tarball is versioned and smaller, though non-official
  url 'https://github.com/psm14/ent/tarball/1.0'
  sha1 'ab45969decd8e79031e9cd1a74dbec3edb802e98'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "ent"

    # Used in the below test
    prefix.install "entest.mas", "entitle.gif"
  end

  test do
    # Adapted from the test in the Makefile and entest.bat
    system "#{bin}/ent #{prefix}/entitle.gif > entest.bak"
    # The single > here was also in entest.bat
    system "#{bin}/ent -c #{prefix}/entitle.gif > entest.bak"
    system "#{bin}/ent -fc #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -b #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -bc #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -t #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -ct #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -ft #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -bt #{prefix}/entitle.gif >> entest.bak"
    system "#{bin}/ent -bct #{prefix}/entitle.gif >> entest.bak"
    system "diff entest.bak #{prefix}/entest.mas"
  end
end
