require 'formula'

class Libmp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.8.2/libmp3splt-0.8.2.tar.gz'
  sha1 '5c8539391e26d047c30360b1dde2c08e6a02061f'

  depends_on 'libtool' => :build
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
