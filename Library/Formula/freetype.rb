require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'http://downloads.sf.net/project/freetype/freetype2/2.4.11/freetype-2.4.11.tar.gz'
  sha1 'a8373512281f74a53713904050e0d71c026bf5cf'

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/freetype-config", '--cflags', '--libs', '--ftversion',
      '--exec-prefix', '--prefix'
  end
end
