require 'formula'

class Portaudio < Formula
  homepage 'http://www.portaudio.com'
  url 'http://www.portaudio.com/archives/pa_stable_v19_20111121.tgz'
  sha1 'f07716c470603729a55b70f5af68f4a6807097eb'

  depends_on 'pkg-config' => :build

  option :universal

  fails_with :llvm do
    build 2334
  end

  # Fix PyAudio compilation on Lion
  def patches
    { :p0 =>
      "https://trac.macports.org/export/94150/trunk/dports/audio/portaudio/files/patch-include__pa_mac_core.h.diff"
    }
  end if MacOS.version >= :lion

  def install
    ENV.universal_binary if build.universal?

    args = [ "--prefix=#{prefix}",
             "--disable-debug",
             "--disable-dependency-tracking",
             # portaudio builds universal unless told not to
             "--enable-mac-universal=#{build.universal? ? 'yes' : 'no'}" ]

    system "./configure", *args
    system "make install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h"
  end
end
