require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.14.tar.bz2'
  sha256 'd07c0ffdbbbfdfbb6c65e73fe9c76466e87dbf04b094cbd0abf5fd7d571a4004'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'icu4c' => :recommended

  # Needs newer fontconfig than XQuartz provides for pango
  depends_on 'fontconfig'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

end
