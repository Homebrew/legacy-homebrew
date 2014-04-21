require 'formula'

class Ffmpeg2theora < Formula
  homepage 'http://v2v.cc/~j/ffmpeg2theora/'
  url 'http://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.29.tar.bz2'
  sha1 '7e78c5ddb8740b33a6ae4c9da76047bd8e662791'

  head 'http://svn.xiph.org/trunk/ffmpeg2theora'

  depends_on 'pkg-config' => :build
  depends_on 'scons' => :build
  depends_on 'ffmpeg'
  depends_on 'libkate' => :optional
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'theora'

  # Fixes build with ffmpeg 2.x by removing use of deprecated constant
  patch do
    url "http://git.xiph.org/?p=ffmpeg2theora.git;a=patch;h=d3435a6a83dc656379de9e6523ecf8d565da6ca6"
    sha1 "5a3e48c386ac077ab58afa6c49631c88f8f85929"
  end

  def install
    args = ["prefix=#{prefix}", "mandir=PREFIX/share/man"]
    args << "libkate=1" if Formula['libkate'].installed?
    scons "install", *args
  end
end
