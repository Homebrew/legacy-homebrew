require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.16.tar.bz2'
  sha256 '6da7e032f705d8a5c91487cd296628d64975672a5b0c1704829cf2285072c92b'

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
