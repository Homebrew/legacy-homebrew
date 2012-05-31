require 'formula'

class Sc68 < Formula
  url 'http://downloads.sourceforge.net/project/sc68/sc68/2.2.1/sc68-2.2.1.tar.gz'
  homepage 'http://sc68.atari.org/project.html'
  md5 '84aa948f76274361f7e78c3563951eff'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end

  def test
    # SC68 ships with a sample module; test attempts to print its metadata
    system "#{bin}/info68", "#{share}/sc68/Sample/About-Intro.sc68", "-C", ": ", "-N", "-L"
  end
end
