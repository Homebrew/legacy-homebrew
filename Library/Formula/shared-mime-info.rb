require 'formula'

class SharedMimeInfo < Formula
  url 'http://freedesktop.org/~hadess/shared-mime-info-0.90.tar.bz2'
  homepage 'http://www.freedesktop.org/wiki/Software/shared-mime-info'
  md5 '967d68d3890ba3994cfce3adf5b8f15b'

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
