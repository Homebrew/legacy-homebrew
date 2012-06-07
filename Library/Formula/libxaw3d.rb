require 'formula'

class Libxaw3d < Formula
  homepage 'http://cgit.freedesktop.org/xorg/lib/libXaw3d'
  url 'http://xorg.freedesktop.org/archive/individual/lib/libXaw3d-1.6.2.tar.bz2'
  sha1 '0b1db72e9d5be0edae57cda213860c0289fac12f'

  def install
    # This is used so the build can find 'xorg-macros.pc'
    ENV['PKG_CONFIG_PATH'] = '/usr/X11/share/pkgconfig'
    system './configure', "--prefix=#{prefix}", '--enable-multiplane-bitmaps',
                          '--disable-dependency-tracking'
    system 'make install'
  end
end
