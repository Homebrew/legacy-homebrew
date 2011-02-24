require 'formula'

class Libgda <Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/libgda/4.2/libgda-4.2.5.tar.bz2'
  homepage 'http://www.gnome-db.org/'
  sha256 'b98d6063469a1ba8226d94800732544be629c55132516de741c937e8bf175f13'

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'libxml2'
  depends_on 'pkg-config'
  depends_on 'readline'
  depends_on 'libgcrypt'

  # depends_on 'sqlite'  # brew's sqlite doesn't have necessary options compiled, so skipping for now
  depends_on 'mysql' => :optional

  def install
    ENV.deparallelize

    system "./configure", "--enable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--disable-binreloc", "--without-java" #, "--with-mysql=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end
end
