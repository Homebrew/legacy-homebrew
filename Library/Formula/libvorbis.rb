require 'formula'

class Libvorbis < Formula
  url 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.2.tar.bz2'
  md5 '798a4211221073c1409f26eac4567e8b'
  homepage 'http://vorbis.com'

  head 'http://svn.xiph.org/trunk/vorbis', :using => :svn

  depends_on 'pkg-config' => :build
  depends_on 'libogg'

  if ARGV.build_head?
    depends_on "automake" => :build

    if MacOS.xcode_version >= "4.3"
      depends_on "libtool" => :build
      depends_on "autoconf" => :build
    end
  end

  def install
    if ARGV.build_head?
      system "./autogen.sh"
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
