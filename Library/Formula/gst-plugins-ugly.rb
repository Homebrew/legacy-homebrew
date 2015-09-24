class GstPluginsUgly < Formula
  desc "GStreamer plugins (well-supported, possibly problematic for distributors)"
  homepage "http://gstreamer.freedesktop.org/"
  url "http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.4.5.tar.xz"
  mirror "http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-ugly-1.4.5.tar.xz"
  sha256 "5cd5e81cf618944f4dc935f1669b2125e8bb2fe9cc7dc8dc15b72237aca49067"
  revision 1

  bottle do
    sha256 "c0835a682d672145d898d77070cbb87ac2177cb99fe7eeb0a817a83ace254120" => :el_capitan
    sha256 "a8e8b3809afa54e5208d1b9b55abf8dd6fa37d223c0307038816865f37d34c04" => :yosemite
    sha256 "4c94061b809c7e2448721dece73b643a7f4c2b9b0bfd3188c40b817430285705" => :mavericks
    sha256 "e8cbbb7406940ed09cb7e3b7b2ba487e6eff1e5b14c22301205994ac1e92bc66" => :mountain_lion
  end

  head do
    url "git://anongit.freedesktop.org/gstreamer/gst-plugins-ugly"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-ugly-0.10.17/REQUIREMENTS and Homebrew formulae
  depends_on "dirac" => :optional
  depends_on "mad" => :optional
  depends_on "jpeg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "cdparanoia" => :optional
  depends_on "lame" => :optional
  depends_on "two-lame" => :optional
  depends_on "libshout" => :optional
  depends_on "aalib" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libmpeg2" => :optional
  depends_on "a52dec" => :optional
  depends_on "liboil" => :optional
  depends_on "flac" => :optional
  depends_on "gtk+" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libmms" => :optional
  depends_on "x264" => :optional
  depends_on "opencore-amr" => :optional
  # Does not work with libcdio 0.9

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    if build.with? "opencore-amr"
      # Fixes build error, missing includes.
      # https://github.com/Homebrew/homebrew/issues/14078
      nbcflags = `pkg-config --cflags opencore-amrnb`.chomp
      wbcflags = `pkg-config --cflags opencore-amrwb`.chomp
      ENV["AMRNB_CFLAGS"] = nbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrnb"
      ENV["AMRWB_CFLAGS"] = wbcflags + "-I#{HOMEBREW_PREFIX}/include/opencore-amrwb"
    else
      args << "--disable-amrnb" << "--disable-amrwb"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
