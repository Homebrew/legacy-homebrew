require 'formula'

class Portaudio < Formula
  url 'http://www.portaudio.com/archives/pa_stable_v19_20071207.tar.gz'
  homepage 'http://www.portaudio.com'
  md5 'd2943e4469834b25afe62cc51adc025f'

  depends_on 'pkg-config' => :build

  fails_with_llvm :build => 2334

  def options
    [["--universal", "Build a universal binary."]]
  end

  # Use the MacPort patches that fix compiling against newer OS X SDKs
  def patches
    {:p0 => [
      "https://trac.macports.org/export/77586/trunk/dports/audio/portaudio/files/patch-configure",
      "https://trac.macports.org/export/77586/trunk/dports/audio/portaudio/files/patch-src__hostapi__coreaudio__pa_mac_core.c",
      "https://trac.macports.org/export/77586/trunk/dports/audio/portaudio/files/patch-src__common__pa_types.h"
    ]}
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h"
  end
end
