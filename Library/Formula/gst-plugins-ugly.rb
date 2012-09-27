require 'formula'

class GstPluginsUgly < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.bz2'
  sha256 '1ca90059275c0f5dca71d4d1601a8f429b7852baed0723e820703b977e2c8df0'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-ugly-0.10.17/REQUIREMENTS and Homebrew formulas
  depends_on 'dirac' => :optional
  depends_on 'mad' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'cdparanoia' => :optional
  depends_on 'lame' => :optional
  depends_on 'two-lame' => :optional
  depends_on 'libshout' => :optional
  depends_on 'aalib' => :optional
  depends_on 'libcaca' => :optional
  depends_on 'libdvdread' => :optional
  depends_on 'sdl' => :optional
  depends_on 'libmpeg2' => :optional
  depends_on 'a52dec' => :optional
  depends_on 'liboil' => :optional
  depends_on 'flac' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'pango' => :optional
  depends_on 'theora' => :optional
  depends_on 'libmms' => :optional
  depends_on 'x264' => :optional
  depends_on 'opencore-amr' => :optional
  depends_on 'libcdio' => :optional

  def install
    ENV.append "CFLAGS", "-no-cpp-precomp -funroll-loops -fstrict-aliasing"

    # Fixes build error, missing includes.
    # https://github.com/mxcl/homebrew/issues/14078
    nbcflags = `pkg-config --cflags opencore-amrnb`.chomp
    wbcflags = `pkg-config --cflags opencore-amrwb`.chomp
    ENV['AMRNB_CFLAGS'] = nbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrnb"
    ENV['AMRWB_CFLAGS'] = wbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrwb"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
