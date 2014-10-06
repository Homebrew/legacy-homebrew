require 'formula'

class SharedMimeInfo < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/shared-mime-info'
  url 'http://freedesktop.org/~hadess/shared-mime-info-1.3.tar.xz'
  sha1 'dfc8f2724df2172be2f2782be0c40c23e1d8f54f'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    # Disable the post-install update-mimedb due to crash
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-update-mimedb"
    system "make install"
  end
end
