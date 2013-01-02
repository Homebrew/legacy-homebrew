require 'formula'

class Mpgtx < Formula
  url 'http://sourceforge.net/projects/mpgtx/files/mpgtx/1.3.1/mpgtx-1.3.1.tar.gz'
  homepage 'http://mpgtx.sourceforge.net'
  sha1 '58b3d18b6dac968e8dd969a7b33c8a8fc31569cd'

  def install
    system "./configure", "--parachute", "--prefix=#{prefix}", "--manprefix=#{man}"
    system "make"
    system "make install cpflags=RP" # Overide BSD incompatible cp flags set in makefile.
  end
end
