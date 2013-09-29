require 'formula'

class RtAudio < Formula
  homepage 'http://www.music.mcgill.ca/~gary/rtaudio/'
  url 'http://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-4.0.12.tar.gz'
  sha1 'a9a4783183e47f07cff0c62d3882ee95b4eefc4d'

  def install
    ENV.j1 # makefile isn't parallel-safe
    system "./configure"
    system "make"
    lib.install "librtaudio.a"
    include.install "RtAudio.h", "RtError.h"
  end
end
