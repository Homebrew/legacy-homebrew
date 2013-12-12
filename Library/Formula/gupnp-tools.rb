require 'formula'

class GupnpTools < Formula
  homepage 'https://wiki.gnome.org/GUPnP/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gupnp-tools/0.8/gupnp-tools-0.8.8.tar.xz'
  sha256 '32ae89bc8d2b2777ca127d91509086fa7285a9211ff3ad1c2e68d17a137c0d98'
  
  depends_on :x11
  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gupnp'
  depends_on 'gupnp-av'
  depends_on 'gtk+3'
  depends_on 'gnome-icon-theme'
  depends_on 'ossp-uuid'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end