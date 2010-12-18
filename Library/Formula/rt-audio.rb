require 'formula'

class RtAudio <Formula
  url 'http://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-4.0.7.tar.gz'
  homepage 'http://www.music.mcgill.ca/~gary/rtaudio/'
  md5 '5d1292abccffa37505d9c4cc177b1e4f'

  def install
    system "./configure"
    system "make"
    lib.install "librtaudio.a"
    include.install ["RtAudio.h", "RtError.h"]
  end
end
