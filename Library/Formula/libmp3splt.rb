require 'formula'

class Libmp3splt < Formula
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.6.1a/libmp3splt-0.6.1a.tar.gz'
  homepage 'http://mp3splt.sourceforge.net'
  md5 'a6a00d83e49adf27abb7a0cb0ea384a4'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libvorbis'

  def patches
    # fixes unneeded dependency on autopoint and uses glibtoolize instead of libtoolize
    "https://gist.github.com/raw/1034717/931c582cba12d5afcbaa3edd6032baa25bebf5d8/autogen.sh.patch"
  end

  def install
    ENV.append 'ACLOCAL_FLAGS', '-I/usr/local/share/aclocal'
    system "./autogen.sh"
    system "autoconf"
    system "automake"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
