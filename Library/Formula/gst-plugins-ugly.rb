require 'formula'

class GstPluginsUgly < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.0.10.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-ugly-1.0.10.tar.xz'
  sha256 'bed3510e09f036e7609e8d291535c395d25109b1180324b16859f475eac3a3c0'

  head 'git://anongit.freedesktop.org/gstreamer/gst-plugins-ugly'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-ugly-0.10.17/REQUIREMENTS and Homebrew formulae
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
  # Does not work with libcdio 0.9

  def install
    ENV.append "CFLAGS", "-no-cpp-precomp -funroll-loops -fstrict-aliasing"

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV.append "NOCONFIGURE", "yes"
      system "./autogen.sh"
    end

    if build.with? "opencore-amr"
      # Fixes build error, missing includes.
      # https://github.com/mxcl/homebrew/issues/14078
      nbcflags = `pkg-config --cflags opencore-amrnb`.chomp
      wbcflags = `pkg-config --cflags opencore-amrwb`.chomp
      ENV['AMRNB_CFLAGS'] = nbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrnb"
      ENV['AMRWB_CFLAGS'] = wbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrwb"
    else
      args << "--disable-amrnb" << "--disable-amrwb"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
