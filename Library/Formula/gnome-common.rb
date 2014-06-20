require 'formula'

class GnomeCommon < Formula
  homepage 'http://git.gnome.org/browse/gnome-common/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gnome-common/3.12/gnome-common-3.12.0.tar.xz'
  sha256 '18712bc2df6b2dd88a11b9f7f874096d1c0c6e7ebc9cfc0686ef963bd590e1d8'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
