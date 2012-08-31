require 'formula'

class VorbisTools < Formula
  url 'http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz'
  md5 '567e0fb8d321b2cd7124f8208b8b90e6'
  homepage 'http://vorbis.com'

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
