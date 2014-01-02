require 'formula'

class Mkvtoolnix < Formula
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-6.6.0.tar.xz'
  sha1 'e0fb5713fcf21ab81bf187eeb108b05d1f53e347'

  head 'https://github.com/mbunkus/mkvtoolnix.git'

  depends_on 'pkg-config' => :build
  depends_on 'boost' => 'c++11'
  depends_on 'libvorbis'
  depends_on 'libmatroska' => 'c++11'
  depends_on 'libebml' => 'c++11'
  depends_on 'flac' => :optional
  depends_on 'lzo' => :optional

  fails_with :clang do
    build 425
    cause 'Mkvtoolnix requires a C++11 compliant compiler.'
  end

  fails_with :gcc do
    build 5666
    cause 'Mkvtoolnix requires a C++11 compliant compiler.'
  end

  fails_with :gcc => '4.5.4' do
    cause 'Mkvtoolnix requires a C++11 compliant compiler.'
  end

  fails_with :gcc_4_0 do
    cause 'Mkvtoolnix requires a C++11 compliant compiler.'
  end;

  fails_with :llvm do
    build 2336
    cause 'Mkvtoolnix requires a C++11 compliant compiler.'
  end

  def install
    ENV.cxx11

    ENV['ZLIB_CFLAGS'] = '-I/usr/include'
    ENV['ZLIB_LIBS'] = '-L/usr/lib -lz'

    boost = Formula.factory('boost').opt_prefix

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-wxwidgets",
                          "--without-curl",
                          "--with-boost=#{boost}"
    system "./drake", "-j#{ENV.make_jobs}"
    system "./drake install"
  end
end
