require 'formula'

class GnomeDocUtils < Formula
  homepage 'https://live.gnome.org/GnomeDocUtils'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.6.tar.bz2'
  sha256 '091486e370480bf45349ad09dac799211092a02938b26a0d68206172cb6cebbf'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'docbook'
  depends_on 'libxml2' # --with-python
  depends_on 'gettext'

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-scrollkeeper",
            "--enable-build-utils=yes"]

    system "./configure", *args

    # Compilation doesn't work right if we jump straight to make install
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
  Gnome-doc-utils requires libxml2 to be compiled
  with the python modules enabled, to do so:
    $ brew install libxml2 --with-python
  EOS
  end
end

