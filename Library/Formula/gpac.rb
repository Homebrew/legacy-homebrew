# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.wp.mines-telecom.fr/"
  head "https://github.com/gpac/gpac.git"

  stable do
    url "https://github.com/gpac/gpac/archive/v0.5.2.tar.gz"
    sha256 "14de020482fc0452240f368564baa95a71b729980e4f36d94dd75c43ac4d9d5c"
  end
  bottle do
    sha256 "3feeb23cfe274e9e8e42cc1589ccd45a4b9c9006444bfce9205454c242abe205" => :yosemite
    sha256 "495e9d51129841da9b135a8112c34ab831f01dfffb5f18db44e59b83813f16c0" => :mavericks
    sha256 "b6291bcf89fc7ea7232e060ddebc3b5c561009a0923ad54b40ab991875c2fa57" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "a52dec" => :optional
  depends_on "jpeg" => :optional
  depends_on "faad2" => :optional
  depends_on "libogg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "mad" => :optional
  depends_on "sdl" => :optional
  depends_on "theora" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "openjpeg" => :optional

  def install
    # If pulseaudio is linked, the script detects it, but fails to link -lpulse.
    args = ["--disable-pulseaudio",
            "--disable-wx",
            "--prefix=#{prefix}",
            "--mandir=#{man}",]

    if build.with? "x11"
      # gpac build system is barely functional
      args << "--extra-cflags=-I#{MacOS::X11.include}"
      # Force detection of X libs on 64-bit kernel
      args << "--extra-ldflags=-L#{MacOS::X11.lib}"
    else
      # https://github.com/gpac/gpac/issues/166
      inreplace "configure", "has_x11=\"yes\"", "has_x11=\"no\""
      args << "--disable-x11-shm" << "--disable-x11-xv"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "MP4Box", "-h"
  end
end
