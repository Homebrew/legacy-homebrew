require 'formula'

class Transcode < Formula
  url 'http://download.berlios.de/tcforge/transcode-1.1.5.tar.bz2'
  homepage 'http://www.transcoding.org/'
  md5 '41ac6b1c0fe30f3aab286e771fc31b9e'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'libmpeg2'
  depends_on 'a52dec'
  depends_on 'libdv'
  depends_on 'lzo'
  depends_on 'libogg'
  depends_on 'ffmpeg'
  depends_on 'imagemagick'
  depends_on 'libdvdread'
  depends_on 'libquicktime'

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-a52",
            "--enable-faac",
            "--enable-imagemagick",
            "--enable-libdv",
            "--enable-ogg",
            "--enable-libquicktime",
            "--enable-theora",
            "--enable-vorbis",
            "--enable-libxml2",
            "--enable-lzo",
            "--enable-x264",
            "--enable-xvid",
            "--enable-sdl",
            "--without-x"]

    args << "--build=x86_64-apple-darwin10.0.0" if MacOS.prefer_64_bit?

    system './configure', *args
    system "make install"
  end
end
