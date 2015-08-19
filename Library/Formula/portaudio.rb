class Portaudio < Formula
  desc "Cross-platform library for audio I/O"
  homepage "http://www.portaudio.com"
  url "http://www.portaudio.com/archives/pa_stable_v19_20140130.tgz"
  sha256 "8fe024a5f0681e112c6979808f684c3516061cc51d3acc0b726af98fc96c8d57"
  head "https://subversion.assembla.com/svn/portaudio/portaudio/trunk/", :using => :svn

  bottle do
    cellar :any
    revision 1
    sha256 "e52067f235b82d537b44b33048eaa43381c5a4d4185da999d583812f6e4f9ff9" => :yosemite
    sha256 "c032773623fd2cb49b736c6978fa7a765468d8a804f3f8618ecda5fcdd198499" => :mavericks
    sha256 "1386972e0632b4ebe2b2770f1ade4c5921c7726fb7fa70f764f5fe09df085c5e" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-mac-universal=#{build.universal? ? "yes" : "no"}",
                          "--enable-cxx"
    system "make", "install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h"
  end
end
