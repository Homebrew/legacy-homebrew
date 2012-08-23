require 'formula'

class Libgda < Formula
  homepage 'http://www.gnome-db.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgda/5.0/libgda-5.0.3.tar.xz'
  sha256 '82d204361b794103c366bb690484d25814bfc653cb97da0dfcf7c0a13409d1cc'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'readline'
  depends_on 'libgcrypt'

  # brew's sqlite doesn't have necessary options compiled, so skipping as a dep for now
  # adamv: which options does it need?

  def install
    ENV.libxml2
    system "./configure", "--enable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--without-java"
    system "make"
    system "make install"
  end
end
