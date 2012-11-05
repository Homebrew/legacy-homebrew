require 'formula'

class Dromeaudio < Formula
  homepage 'http://www.meandmark.com/quicktimepart1.html'
  url 'http://joshbeam.com/software/dromeaudio/DromeAudio-0.2.1.tar.gz'
  sha1 '4d225a2b00300d04320aafb217d9087b12651be1'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  def test
    system "DromeAudioPlayer"
  end
end
