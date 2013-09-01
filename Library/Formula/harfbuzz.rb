require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.20.tar.bz2'
  sha256 '83384fa03fbcf0c5d8203374bae2efef7dcac650f428d2216d8a6d2251dbbc67'

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
