require 'formula'

class Gegl < Formula
  homepage 'http://www.gegl.org/'
  url 'ftp://ftp.gimp.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2'
  sha1 '764cc66cb3c7b261b8fc18a6268a0e264a91d573'

  option :universal

  depends_on 'babl'
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'intltool' => :build
  depends_on 'pkg-config' => :build

  def install
    # ./configure breaks when optimization is enabled with llvm
    ENV.no_optimization if ENV.compiler == :llvm

    argv = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-docs
    ]
    if build.universal?
      ENV.universal_binary
      # ffmpeg's formula is currently not universal-enabled
      argv << "--without-libavformat"

      opoo 'Compilation may fail at gegl-cpuaccel.c using gcc for a universal build' if ENV.compiler == :gcc
    end

    system "./configure", *argv
    system "make install"
  end
end
