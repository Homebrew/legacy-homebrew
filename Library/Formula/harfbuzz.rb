require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.18.tar.bz2'
  sha256 'fef0fbbc6d6492cb4074a5e26a699d87d88bef8adc25dda62af6077735a7d908'

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
