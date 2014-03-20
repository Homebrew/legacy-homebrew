require 'formula'

class VorbisTools < Formula
  homepage 'http://vorbis.com'
  url 'http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz'
  sha1 'fc6a820bdb5ad6fcac074721fab5c3f96eaf6562'

  depends_on 'pkg-config' => :build
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'libao'
  depends_on 'flac' => :optional

  def install

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-nls",
      "--prefix=#{prefix}"
    ]

    args << "--without-flac" if build.without? 'flac'

    system "./configure", *args
    system "make install"
  end
end
