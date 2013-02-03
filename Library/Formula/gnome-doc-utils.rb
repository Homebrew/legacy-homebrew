require 'formula'

class GnomeDocUtils < Formula
  homepage 'https://live.gnome.org/GnomeDocUtils'
  url 'http://ftp.gnome.org/pub/gnome/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz'
  sha256 'cb0639ffa9550b6ddf3b62f3b1add92fb92ab4690d351f2353cffe668be8c4a6'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'docbook'
  depends_on 'gettext'
  depends_on 'libxml2' => 'with-python'

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
end
