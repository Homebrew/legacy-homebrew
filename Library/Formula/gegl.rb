require 'formula'

class Gegl < Formula
  url 'ftp://ftp.gimp.org/pub/gegl/0.1/gegl-0.1.8.tar.bz2'
  homepage 'http://www.gegl.org/'
  md5 'c8279b86b3d584ee4f503839fc500425'

  depends_on 'babl'
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'pkg-config' => :build

  def options
  [
    ["--universal", "Builds a universal binary"],
  ]
  end

  def install
    # ./configure breaks when optimization is enabled with llvm
    ENV.no_optimization if ENV.use_llvm?

    opoo 'Compilation may fail at gegl-cpuaccel.c using gcc for a universal build' if ARGV.build_universal? && ENV.use_gcc?

    argv = ["--disable-docs", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]
    if ARGV.build_universal?
      ENV.universal_binary if ARGV.build_universal?
      # ffmpeg's formula is currently not universal-enabled
      argv << "--without-libavformat"
    end

    system "./configure", *argv
    system "make install"
  end
end
