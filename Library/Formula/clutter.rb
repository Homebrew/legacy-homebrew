require 'formula'

class Clutter < Formula
  homepage 'http://clutter-project.org/'
  url 'http://source.clutter-project.org/sources/clutter/1.6/clutter-1.6.20.tar.bz2'
  sha256 'c4e40c7a553a0437a3b8c54da440bf54b44114bd83d68d4eeea425fed90e046e'

  depends_on 'pkg-config' => :build
  depends_on 'atk'
  # Cairo is keg-only and usually only used for Leopard builds.
  # But Clutter requires a newer version of Cairo that what comes with Snow Leopard.
  depends_on 'cairo'
  depends_on 'intltool'
  depends_on 'json-glib'
  depends_on 'pango'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-flavour=osx",
                          "--with-imagebackend=quartz",
                          "--disable-introspection"
    system "make install"
  end
end
