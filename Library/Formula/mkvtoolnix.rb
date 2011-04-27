require 'formula'

class Mkvtoolnix < Formula
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-4.7.0.tar.bz2'
  sha1 'eaa688dde0e3218f2f1e7caf7d0d0f94181328c0'
  head 'git://github.com/mbunkus/mkvtoolnix.git'
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'

  depends_on 'boost'
  depends_on 'libvorbis'
  depends_on 'libmatroska'
  depends_on 'flac' => :optional
  depends_on 'lzo' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{HOMEBREW_PREFIX}/lib", # For non-/usr/local prefix
                          "--with-boost-regex=boost_regex-mt" # via macports
    system "./drake -j#{Hardware.processor_count}"
    system "./drake install"
  end
end
