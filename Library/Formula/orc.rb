require 'formula'

class Orc < Formula
  homepage 'http://cgit.freedesktop.org/gstreamer/orc/'
  url 'http://gstreamer.freedesktop.org/src/orc/orc-0.4.21.tar.xz'
  sha1 '519a054cd00a52d1819367a510151742051aedc3'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make install"
  end
end
