require 'formula'

class Scrub < Formula
  url 'http://diskscrub.googlecode.com/files/scrub-2.4.tar.bz2'
  homepage 'http://code.google.com/p/diskscrub/'
  sha1 '1065cde68549cd8b013f2b82bc5bb24922010da7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
