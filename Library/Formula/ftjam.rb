require 'formula'

class Ftjam < Formula
  homepage 'http://www.freetype.org/jam/'
  url 'http://sourceforge.net/projects/freetype/files/ftjam/2.5.2/ftjam-2.5.2.tar.bz2'
  sha1 '08bad35e74ec85c4592d378014586174d22297b5'

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make'
    system 'make install'
  end
end
