require 'formula'

class Mkvtoolnix < Formula
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-5.0.1.tar.bz2'
  sha1 '900211d47ba6cbeb4188bb45a492a2b9edf08ed2'
  head 'https://github.com/mbunkus/mkvtoolnix.git'
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'

  depends_on 'boost'
  depends_on 'libvorbis'
  depends_on 'libmatroska'
  depends_on 'flac' => :optional
  depends_on 'lzo' => :optional

  fails_with :clang do
    build 318
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{HOMEBREW_PREFIX}/lib", # For non-/usr/local prefix
                          "--with-boost-regex=boost_regex-mt" # via macports
    system "./drake", "-j#{ENV.make_jobs}"
    system "./drake install"
  end
end
