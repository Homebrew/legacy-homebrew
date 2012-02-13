require 'formula'

class GstPluginsBad < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.22.tar.bz2'
  sha256 'd8f7102f43ffea076646427115ffdccb3975954f1e9367bd304f7ee01e12070c'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  # These optional dependencies are based on the intersection of
  # gst-plugins-bad-0.10.21/REQUIREMENTS and Homebrew formulas
  depends_on 'dirac' => :optional
  depends_on 'libdvdread' => :optional
  depends_on 'libmms' => :optional

  # These are not mentioned in REQUIREMENTS, but configure look for them
  depends_on 'libexif' => :optional
  depends_on 'faac' => :optional
  depends_on 'faad2' => :optional
  depends_on 'libsndfile' => :optional
  depends_on 'schroedinger' => :optional
  depends_on 'rtmpdump' => :optional

  def install
    ENV.append "CFLAGS", "-no-cpp-precomp -funroll-loops -fstrict-aliasing"
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking", "--disable-sdl"
    system "make"
    system "make install"
  end
end
