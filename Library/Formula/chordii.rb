require 'formula'

class Chordii < Formula
  homepage 'http://www.vromans.org/johan/projects/Chordii/'
  url 'https://downloads.sourceforge.net/project/chordii/chordii/4.5/chordii-4.5.1.tar.gz'
  sha1 '3cdeacf53a08cf2193e35651120e129c2bb5a007'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
