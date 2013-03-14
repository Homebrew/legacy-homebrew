require 'formula'

class VorbisTools < Formula
  homepage 'http://vorbis.com'
  url 'http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz'
  sha1 'fc6a820bdb5ad6fcac074721fab5c3f96eaf6562'

  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'libao'
  depends_on 'flac'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-nls",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
