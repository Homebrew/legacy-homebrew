require 'formula'

class Mpgtx < Formula
  homepage 'http://mpgtx.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/mpgtx/mpgtx/1.3.1/mpgtx-1.3.1.tar.gz'
  sha1 '58b3d18b6dac968e8dd969a7b33c8a8fc31569cd'

  def install
    system "./configure", "--parachute",
                          "--prefix=#{prefix}",
                          "--manprefix=#{man}"
    system "make"
    # Overide BSD incompatible cp flags set in makefile
    system "make install cpflags=RP"
  end
end
