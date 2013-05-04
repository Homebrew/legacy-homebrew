require 'formula'

class SharedMimeInfo < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/shared-mime-info'
  url 'http://freedesktop.org/~hadess/shared-mime-info-1.1.tar.xz'
  sha1 '752668b0cc5729433c99cbad00f21241ec4797ef'

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
