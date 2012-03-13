require 'formula'

class Libgdiplus < Formula
  url 'http://ftp.novell.com/pub/mono/sources/libgdiplus/libgdiplus-2.10.tar.bz2'
  homepage 'http://www.mono-project.com/Libgdiplus'
  md5 '451966e8f637e3a1f02d1d30f900255d'

  depends_on 'gettext'
  depends_on 'libtiff'
  depends_on 'libexif'
  depends_on 'glib'

  def patches
    # fixes compilation against libpng1.5
    # see https://bugs.gentoo.org/355113
    # and https://bugzilla.novell.com/show_bug.cgi?id=666583
    { :p0 => 'http://cvsweb.se.netbsd.org/cgi-bin/bsdweb.cgi/~checkout~/pkgsrc/graphics/libgdiplus/patches/patch-aa?rev=1.9;content-type=text%2Fplain' }
  end if MacOS.lion?

  def install
    ENV.x11

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
