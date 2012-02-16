require 'formula'

class GnomeKeyring < Formula
  homepage 'http://live.gnome.org/GnomeKeyring'
  url 'http://ftp.acc.umu.se/pub/gnome/sources/gnome-keyring/2.28/gnome-keyring-2.28.2.tar.bz2'
  sha256 'd2d686fb2528ee045bbcd9f18d0d452e0eb88c2265a1947f639152b61a5987f6'

  # NOTE
  # 1) 3.X versions of gnome-keyring require GTK+ 3 series
  #
  # 2) gnome-keyring 2.28.2 was last version packaged with
  #       library/gnome-keyring.h
  #       library/gnome-keyring-1.pc.in
  #
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'd-bus'
  depends_on 'glib'
  depends_on 'libgcrypt'
  depends_on 'libtasn'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-root-certs"
    system "make install"
  end
end
