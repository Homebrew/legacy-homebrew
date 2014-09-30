require 'formula'

class GstPluginsBad < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.3.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-bad-1.4.3.tar.xz'
  sha256 'a6840080c469d0db51d6d4d0f7c42c97b3c8c01942f24401c61b1ad36726b97c'

  bottle do
    sha1 "e4cfbc3811c0c1b8e8d97e7fa6ee2e5ee0bad5f9" => :mavericks
    sha1 "7ab595c50dd3589b91384c357ad6afe4c5ff9ab8" => :mountain_lion
    sha1 "db628264c53bc0747b7f789dea7e4a76bfd77b62" => :lion
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
