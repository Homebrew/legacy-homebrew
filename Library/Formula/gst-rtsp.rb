require 'formula'

class GstRtsp < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-rtsp/gst-rtsp-0.10.8.tar.bz2'
  sha256 '9915887cf8515bda87462c69738646afb715b597613edc7340477ccab63a6617'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gst-plugins-base'

  if MacOS.xcode_version >= "4.3"
    # when and if the tarball provides configure, remove autogen.sh and these deps
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}",
                           "--disable-schemas-install",
                           "--disable-gtk-doc"
    system "make"
    system "make install"
  end
end
