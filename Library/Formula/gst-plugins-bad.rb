require 'formula'

class GstPluginsBad < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.0.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-bad-1.4.0.tar.xz'
  sha256 'ff2cb754f7725b205aec66002b1406e440f3a03194b6cad2d126ef5cd00902f9'

  bottle do
    sha1 "f8079f35006fb7cfe3f853425d2f6c49904346ac" => :mavericks
    sha1 "5b0fa02c6824fd1171d958f9101eb52990b86781" => :mountain_lion
    sha1 "24c489fa9fcfa224451e5ae7c55a70fea995b39f" => :lion
  end

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
