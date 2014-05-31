require 'formula'

class TransmissionRemoteGtk < Formula
  homepage 'http://code.google.com/p/transmission-remote-gtk/'
  url 'https://transmission-remote-gtk.googlecode.com/files/transmission-remote-gtk-1.1.1.tar.gz'
  sha1 '2fdfe0526a64a2ee5f24f1c31ca55771ea00ac7b'

  depends_on :x11
  depends_on 'intltool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gtk+3'
  depends_on 'json-glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-gtk3"
    system "make install"
  end
end
