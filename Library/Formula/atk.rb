require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.0/atk-2.0.0.tar.bz2'
  sha256 '5dbdc35f7f5b3f0748039bb3faa7cd5e45ec3d337a539772bc73acd0dfb55afd'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end
end
