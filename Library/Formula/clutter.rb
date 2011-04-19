require 'formula'

class Clutter < Formula
  homepage 'http://clutter-project.org/'
  url 'http://source.clutter-project.org/sources/clutter/1.6/clutter-1.6.14.tar.bz2'
  sha256 '0564e57ca8eb24e76014627c0bb28a80a6c01b620ba14bc4198365562549576d'

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
                          "--with-imagebackend=quartz"
    system "make install"
  end
end
