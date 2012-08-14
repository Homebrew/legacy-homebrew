require 'formula'

class Libmp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.7.2/libmp3splt-0.7.2.tar.gz'
  md5 '848817d1d980729aec99bbc62caddd76'

  # Linking fails on 10.6 (and lower?) without a duplicate libtool; see #10350
  unless MacOS.lion?
    depends_on 'libtool' => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libvorbis'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
