require 'formula'

class GstPluginsBad < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.4.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-bad-1.4.4.tar.xz'
  sha256 'e41b36105c0a13a2cb1ff9f559714e839b82dc3841484cd664790fb7947e55c7'

  bottle do
    sha1 "7cdb7699744842c077459fc7498a269477c04425" => :mavericks
    sha1 "95b4182a6da12cd50f8319256581a3afbce58607" => :mountain_lion
    sha1 "72610ec1a7734f6a5e100b073b669698cc7e8080" => :lion
  end

  head do
    url 'git://anongit.freedesktop.org/gstreamer/gst-plugins-bad'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'xz' => :build
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
