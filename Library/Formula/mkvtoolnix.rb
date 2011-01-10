require 'formula'

class Mkvtoolnix <Formula
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-4.4.0.tar.bz2'
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'
  sha1 'c5e6cbc2fb522ba6653124a2eef6b416bafc488a'

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
