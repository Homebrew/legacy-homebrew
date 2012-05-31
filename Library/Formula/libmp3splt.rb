require 'formula'

class Libmp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.7.2/libmp3splt-0.7.2.tar.gz'
  md5 '848817d1d980729aec99bbc62caddd76'

  unless MacOS.lion?
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libvorbis'

  def install
    unless MacOS.lion?
      system "./autogen.sh"
      system "autoconf"
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
