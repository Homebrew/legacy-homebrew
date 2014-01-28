require 'formula'

class SharedMimeInfo < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/shared-mime-info'
  url 'http://freedesktop.org/~hadess/shared-mime-info-1.2.tar.xz'
  sha1 '4c1598e30c632f1f9e825d95da7e3a1f47a32948'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    # Disable the post-install update-mimedb due to crash
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-update-mimedb"
    system "make install"
  end
end
