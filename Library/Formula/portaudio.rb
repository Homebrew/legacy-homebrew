require 'formula'

class Portaudio < Formula
  url 'http://www.portaudio.com/archives/pa_stable_candidate_v19_20111026.tgz'
  homepage 'http://www.portaudio.com'
  md5 'a8340787619a72aab945e6d324ed80a3'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h"
  end
end
