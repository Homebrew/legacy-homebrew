require 'formula'

class GstPluginsBad < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.0.9.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-bad-1.0.9.tar.xz'
  sha256 '69d236b1d8188270a3f51f6710146d0ca63c2f1a9f6cfbab3399ef01b9498f75'

  head 'git://anongit.freedesktop.org/gstreamer/gst-plugins-bad'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

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

    args = %W[
      --prefix=#{prefix}
      --disable-apple_media
      --disable-yadif
      --disable-sdl
      --disable-osx_video
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV.append "NOCONFIGURE", "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
