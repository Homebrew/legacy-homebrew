require 'formula'

class Orc < Formula
  homepage 'http://cgit.freedesktop.org/gstreamer/orc/'
  url 'http://gstreamer.freedesktop.org/src/orc/orc-0.4.19.tar.gz'
  sha1 '6186a6a5faefe6b61d55e5406c7365d69b91c982'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make install"
  end
end
