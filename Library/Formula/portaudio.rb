require 'formula'

class Portaudio < Formula
  url 'http://www.portaudio.com/archives/pa_stable_v19_20071207.tar.gz'
  homepage 'http://www.portaudio.com'
  md5 'd2943e4469834b25afe62cc51adc025f'

  depends_on 'pkg-config' => :build

  fails_with_llvm

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"

    # remove arch flags else we get errors like:
    #   lipo: can't figure out the architecture type
    inreplace 'Makefile', /-arch (x64_64|ppc64|i386|ppc)/, ''

    system "make install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h"
  end
end
