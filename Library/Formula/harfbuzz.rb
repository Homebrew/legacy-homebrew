require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.28.tar.bz2'
  sha256 'a567f7c58018af0a9751e18641fd8434bfcef8307122dabe47dd652ce8bde048'

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
