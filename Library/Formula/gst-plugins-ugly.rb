require 'formula'

class GstPluginsUgly < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.4.3.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-ugly-1.4.3.tar.xz'
  sha256 'd581592a82cf3930361430d38436c30a58d8b6c249cad18f7f213b203e206d46'

  bottle do
    sha1 "7bfe45bf9e96a93338d52d12d61e9d98d6c6c025" => :mavericks
    sha1 "caabe8b129fc750ea1b6b082a1e8db1767f81112" => :mountain_lion
    sha1 "5e9a2adce47c29d390eb65ef94bfc052a42d3595" => :lion
  end

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gst-plugins-ugly'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
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
