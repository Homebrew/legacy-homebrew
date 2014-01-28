require 'formula'

class Libvorbis < Formula
  homepage 'http://vorbis.com'
  url 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.xz'
  sha1 'b99724acdf3577982b3146b9430d765995ecf9e1'

  head do
    url 'http://svn.xiph.org/trunk/vorbis'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libogg'

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
