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

  def install
    args = ["prefix=#{prefix}", "mandir=PREFIX/share/man"]
    args << "libkate=1" if Formula.factory('libkate').installed?
    system "scons", "install", *args
  end
end
