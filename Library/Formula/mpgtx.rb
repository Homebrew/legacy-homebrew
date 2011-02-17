require 'formula'

class Mpgtx <Formula
  url 'http://sourceforge.net/projects/mpgtx/files/mpgtx/1.3.1/mpgtx-1.3.1.tar.gz'
  homepage 'http://mpgtx.sourceforge.net'
  md5 'd628060aa04ad3b40a175bf35f5167cf'

  def install
    system "./configure", "--parachute", "--prefix=#{prefix}", "--manprefix=#{man}"
    system "make"
    system "make install cpflags=RP" # Overide BSD incompatible cp flags set in makefile.
  end
end