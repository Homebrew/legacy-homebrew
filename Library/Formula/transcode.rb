require 'formula'

class Transcode <Formula
  url 'http://download.berlios.de/tcforge/transcode-1.1.0.tar.bz2'
  homepage 'http://www.transcoding.org/'
  md5 '5ca205e32b546402a48ea8004a7b3232'

  depends_on 'libmpeg2'
  depends_on 'libdvdread'
  depends_on 'lame'

  depends_on 'a52dec'
  depends_on 'faac'
  depends_on 'imagemagick'
  depends_on 'libdv'
  depends_on 'libogg'
  depends_on 'libquicktime'
  depends_on 'theora'
  depends_on 'libvorbis'
  depends_on 'libxml2'
  depends_on 'lzo'
  depends_on 'x264'
  depends_on 'xvid'
  depends_on 'sdl'

  def install
    ENV.x11

    if snow_leopard_64?
      buildname = 'x86_64-apple-darwin'
    else
      buildname = nil
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", 
                          (buildname ? "--build=#{buildname}" : ""),
                          "--disable-mmx",
                          "--enable-libmpeg2",
                          "--enable-libmpeg2convert",
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
                          "--enable-xvid"
                          "--enable-sdl"

    system "make install"
  end
end
