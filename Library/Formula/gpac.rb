require 'formula'

#
# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs
#

class Gpac < Formula
  url 'http://downloads.sourceforge.net/gpac/gpac-0.4.5.tar.gz'
  homepage 'http://gpac.sourceforge.net/index.php'
  md5 '755e8c438a48ebdb13525dd491f5b0d1'
  head 'https://gpac.svn.sourceforge.net/svnroot/gpac/trunk/gpac', :using => :svn

  depends_on :x11

  depends_on 'a52dec' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'faad2' => :optional
  depends_on 'libogg' => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'mad' => :optional
  depends_on 'sdl' => :optional
  depends_on 'theora' => :optional

  depends_on 'ffmpeg' => :optional if ARGV.build_head?
  depends_on 'openjpeg' => :optional if ARGV.build_head?

  def install
    ENV.deparallelize

    args = ["--disable-wx",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            # gpac build system is barely functional
            "--extra-cflags=-I#{MacOS.x11_prefix}/include",
            # Force detection of X libs on 64-bit kernel
            "--extra-ldflags=-L#{MacOS.x11_prefix}/lib"]
    args << "--use-ffmpeg=no" unless ARGV.build_head?
    args << "--use-openjpeg=no" unless ARGV.build_head?

    system "chmod +x configure"
    system "./configure", *args
    system "make"
    system "make install"
  end
end
