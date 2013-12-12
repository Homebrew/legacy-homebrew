require 'formula'

class GupnpAv < Formula
  homepage 'https://wiki.gnome.org/GUPnP/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gupnp-av/0.12/gupnp-av-0.12.4.tar.xz'
  sha256 '548a9cef8ab3007734e20a4ce284c422ae299b7e024a4824299f6ae7e3dd7a5b'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gupnp'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
