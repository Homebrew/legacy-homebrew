require 'formula'

class Mkvtoolnix <Formula
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-4.3.0.tar.bz2'
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'
  sha1 '70ae0d5769d65b032c15eedc01e914be3245779e'

  depends_on 'boost'
  depends_on 'libvorbis'
  depends_on 'libmatroska'
  depends_on 'flac' => :optional
  depends_on 'lzo' => :optional

  # Fix installs for non-bash shells.
  # Can be removed in the next post-4.3.0 version.
  def patches
    "http://www.bunkus.org/cgi-bin/gitweb.cgi?p=mkvtoolnix.git;a=blobdiff_plain;f=build-config.in;h=e109f8007887b29049d6c42a7efd148ec06933b6;hp=ef8fe4c4b0df6a8d628d75b4fa872d563f86e3c9;hb=8682a0316ace57c74333c35a27d5183015b57c9f;hpb=82e37f12f4e51bdb1b9f10b7832d0d33527740f9"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{HOMEBREW_PREFIX}/lib", # For non-/usr/local prefix
                          "--with-boost-regex=boost_regex-mt" # via macports
    system "./drake -j#{Hardware.processor_count}"
    system "./drake install"
  end
end
