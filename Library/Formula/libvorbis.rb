require 'formula'

class Libvorbis < Formula
  homepage 'http://vorbis.com'
  url 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.xz'
  sha1 '31d1a0ec4815bf1ee638b0f2850f03efcd48022a'

  head 'http://svn.xiph.org/trunk/vorbis'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libogg'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
