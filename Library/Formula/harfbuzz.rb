require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.23.tar.bz2'
  sha256 '171ab7f58e7243082a4582f4d1f21b3f44462931ea92a6909d303ad3614794c7'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'cairo'
  depends_on 'icu4c' => :recommended
  depends_on :freetype

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-icu" if build.with? 'icu4c'
    system "./configure", *args
    system "make install"
  end
end
