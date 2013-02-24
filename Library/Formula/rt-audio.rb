require 'formula'

class RtAudio < Formula
  homepage 'http://www.music.mcgill.ca/~gary/rtaudio/'
  url 'http://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-4.0.7.tar.gz'
  sha1 '56c647cc664dd021df1a6fa30fe96c04100c2b75'

  def install
    system "./configure"
    system "make"
    lib.install "librtaudio.a"
    include.install "RtAudio.h", "RtError.h"
  end
end
