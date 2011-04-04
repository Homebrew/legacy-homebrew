require 'formula'

class Netris < Formula
  url 'ftp://ftp.netris.org/pub/netris/netris-0.52.tar.gz'
  homepage 'http://www.netris.org/'
  md5 'b55af5697175ee06f7c6e40101979c38'

  # Debian has been applying fixes and security patches, so let's re-use their work.
  # Also fixes case of "TERM=xterm-color256" which otherwise segfaults.
  def patches
    [
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/01_multi-games-with-scoring',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/02_line-count-patch',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/03_staircase-effect-fix',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/04_robot-close-fixup',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/05_init-static-vars',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/06_curses.c-include-term.h',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/07_curses.c-include-time.h',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/08_various-fixes',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/09_ipv6',
      'http://patch-tracker.debian.org/patch/series/dl/netris/0.52-9/10_fix-memory-leak',
    ]
  end

  def install
    system "sh Configure"
    system "make"
    bin.install "netris"
  end
end
