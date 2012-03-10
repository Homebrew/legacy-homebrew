require 'formula'

class Libgda < Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/libgda/4.2/libgda-4.2.5.tar.bz2'
  homepage 'http://www.gnome-db.org/'
  sha256 'b98d6063469a1ba8226d94800732544be629c55132516de741c937e8bf175f13'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'readline'
  depends_on 'libgcrypt'

  # brew's sqlite doesn't have necessary options compiled, so skipping as a dep for now
  # adamv: which options does it need?

  def install
    system "./configure", "--enable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--without-java"
    system "make"
    system "make install"
  end
end
