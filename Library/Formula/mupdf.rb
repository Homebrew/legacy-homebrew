require 'formula'

class Mupdf < Formula
  homepage 'http://mupdf.com'
  url 'http://mupdf.googlecode.com/files/mupdf-1.3-source.tar.gz'
  sha1 '082325aceb5565b07b82c2b6cc52a97533e03cf9'

  depends_on :macos => :snow_leopard

  depends_on 'jpeg'
  depends_on 'openjpeg'
  depends_on 'jbig2dec'
  depends_on :x11 # libpng, freetype and the X11 libs

  def install
    openjpeg = Formula.factory 'openjpeg'
    ENV.append 'CPPFLAGS', "-I#{Dir[openjpeg.include/'openjpeg-*'].first}"
    ENV.append 'CFLAGS', '-DNDEBUG'
    ENV['SYS_FREETYPE_INC'] = "-I#{MacOS::X11.include}/freetype2"

    system "make", "install", "prefix=#{prefix}"
  end
end
