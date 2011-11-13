require 'formula'

class GnomeDocUtils < Formula
  homepage 'https://live.gnome.org/GnomeDocUtils'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.6.tar.bz2'
  sha256 '091486e370480bf45349ad09dac799211092a02938b26a0d68206172cb6cebbf'

  # Gnome-doc-utils requires libxml2 to be compiled with the python modules
  # enabled:
  #
  # $ brew install libxml2 --with-python

  depends_on 'docbook'
  depends_on 'pkg-config'
  depends_on 'intltool'
  depends_on 'libxml2' # --with-python

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install

    system "./configure", "--disable-scrollkeeper"

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make install"

  end
end

