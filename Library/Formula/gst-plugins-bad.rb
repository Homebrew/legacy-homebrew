require 'formula'

class GstPluginsBad < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.2.4.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-bad-1.2.4.tar.xz'
  sha256 '984c133ec9d5d705e313d9e2bbd1472b93c6567460602a9a316578925ffe2eca'

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gst-plugins-bad'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  depends_on 'dirac' => :optional
  depends_on 'faac' => :optional
  depends_on 'faad2' => :optional
  depends_on 'gnutls' => :optional
  depends_on 'libdvdread' => :optional
  depends_on 'libexif' => :optional
  depends_on 'libmms' => :optional
  depends_on 'rtmpdump' => :optional
  depends_on 'schroedinger' => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-apple_media
      --disable-yadif
      --disable-sdl
      --disable-debug
      --disable-dependency-tracking
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
