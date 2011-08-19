require 'formula'

class Libmp3splt < Formula
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.6.1a/libmp3splt-0.6.1a.tar.gz'
  homepage 'http://mp3splt.sourceforge.net'
  md5 'a6a00d83e49adf27abb7a0cb0ea384a4'

  depends_on 'gettext'
  depends_on 'pkg-config'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'libmad'
  depends_on 'libvorbis'

  def patches
    # fixes unneeded depencency on autopoint and uses glibtoolize instead of libtoolize
    "https://gist.github.com/raw/1034717/931c582cba12d5afcbaa3edd6032baa25bebf5d8/autogen.sh.patch"
  end

  def install
    system "ACLOCAL_FLAGS=\"-I /usr/local/share/aclocal $ACLOCAL_FLAGS\" ./autogen.sh"
    system "autoconf && automake"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
