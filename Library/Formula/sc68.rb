require 'formula'

class Sc68 < Formula
  homepage 'http://sc68.atari.org/project.html'
  url 'https://downloads.sourceforge.net/project/sc68/sc68/2.2.1/sc68-2.2.1.tar.gz'
  sha1 '503e8b027b1b8f98925344bc591248ab5f19f59d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end

  test do
    # SC68 ships with a sample module; test attempts to print its metadata
    system "#{bin}/info68", "#{share}/sc68/Sample/About-Intro.sc68", "-C", ": ", "-N", "-L"
  end
end
