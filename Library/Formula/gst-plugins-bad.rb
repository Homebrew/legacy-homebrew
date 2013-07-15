require 'formula'

class GstPluginsBad < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.0.8.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-bad-1.0.8.tar.xz'
  sha256 '6949b5532034fc37d5a874e4e3330107767238bc4def9f769b8193124e2420cc'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  # These optional dependencies are based on the intersection of
  # gst-plugins-bad-0.10.21/REQUIREMENTS and Homebrew formulae
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
    ENV.append "CFLAGS", "-no-cpp-precomp" unless ENV.compiler == :clang
    ENV.append "CFLAGS", "-funroll-loops -fstrict-aliasing"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdl",
                          # gst/interfaces/propertyprobe.h is missing from gst-plugins-base 1.0.x
                          "--disable-osx_video"
    system "make"
    system "make install"
  end
end
