require 'formula'

class GnomeDocUtils < Formula
  homepage 'https://live.gnome.org/GnomeDocUtils'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.6.tar.bz2'
  sha256 '091486e370480bf45349ad09dac799211092a02938b26a0d68206172cb6cebbf'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'docbook'
  depends_on 'gettext'

  # libxml2 must be installed --with-python, and since it is keg-only, the
  # Python module must also be symlinked into site-packages or put on the
  # PYTHONPATH.
  depends_on 'libxml2'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    # TODO this should possibly be moved up into build.rb
    pydir = 'python' + `python -c 'import sys;print(sys.version[:3])'`.strip
    libxml2 = Formula.factory('libxml2')
    ENV.prepend 'PYTHONPATH', libxml2.lib/pydir/'site-packages', ':'

    # Find our docbook catalog
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-scrollkeeper",
                          "--enable-build-utils=yes"

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

