require 'formula'

class GnomeCommon < Formula
  homepage 'http://git.gnome.org/browse/gnome-common/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gnome-common/3.4/gnome-common-3.4.0.1.tar.xz'
  sha256 '3d92a5d1dae550c409f644d87a4bba17342e14fb11ce8b1e58757ce35f3a46f7'

  depends_on 'xz' => :build

  def patches
    # Make gnome-autogen.sh accept our automake-1.12.x as >= 1.9.
    # Remove when at version >= 3.4.0.2
    'http://git.gnome.org/browse/gnome-common/patch/?id=1fed4ee7015b89a1ac4c4a535aeb753e820e4970'
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
