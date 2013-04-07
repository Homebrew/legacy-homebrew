require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.15.tar.bz2'
  sha256 '214f919c2c998eb1316dd1a14a13adf27460e706a709488777076babf7fbbf1d'

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
