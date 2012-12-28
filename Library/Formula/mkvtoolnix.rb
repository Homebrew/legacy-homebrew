require 'formula'

class Mkvtoolnix < Formula
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-5.9.0.tar.bz2'
  sha256 'd913f531331c3332d2fb334c872ea19bfea7293dfedc4bf33ae7162e4efcbde1'

  head 'https://github.com/mbunkus/mkvtoolnix.git'

  depends_on 'boost' => 'with-c++11'
  depends_on 'libebml'
  depends_on 'libvorbis'
  depends_on 'libmatroska'
  depends_on 'flac' => :optional
  depends_on 'lzo' => :optional
  depends_on 'homebrew/dupes/zlib'

  fails_with :clang do
    build 318
    cause "Compilation errors with older clang."
  end

  def install
    ENV['CXXFLAGS'] = " -stdlib=libc++"
    system "./configure", "--disable-debug", "--prefix=#{prefix}",
                          "--disable-gui",
                          "--disable-wxwidgets",
                          "--with-boost=#{HOMEBREW_PREFIX}",
                          "--with-extra-libs=#{HOMEBREW_PREFIX}/lib",
                          "--with-extra-includes=#{HOMEBREW_PREFIX}/includes",
                          "--disable-optimization"

    system "./drake", "-j#{ENV.make_jobs}"
    system "./drake install"
  end
end
