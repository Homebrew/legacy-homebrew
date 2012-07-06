require 'formula'

class Libvorbis < Formula
  homepage 'http://vorbis.com'
  url 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.xz'
  sha1 '31d1a0ec4815bf1ee638b0f2850f03efcd48022a'

  head 'http://svn.xiph.org/trunk/vorbis'

  depends_on 'xz' => :build
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

    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
