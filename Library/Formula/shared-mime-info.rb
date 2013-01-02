require 'formula'

class SharedMimeInfo < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/shared-mime-info'
  url 'http://freedesktop.org/~hadess/shared-mime-info-1.0.tar.xz'
  sha1 '146dbad62f5450116b0353f88bb8e700f0034013'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'glib'

  def install
    # Disable the post-install update-mimedb due to crash
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-update-mimedb"
    system "make install"
  end
end
