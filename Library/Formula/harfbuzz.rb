require 'formula'

class Harfbuzz < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/HarfBuzz'
  url 'http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.12.tar.bz2'
  sha256 'c653f70a275e98d109a9f1271373a6e80978c97298d723cb3f370351852f9da5'

  depends_on 'pkg-config' => :build

  # Requires newer autotools on all platforms
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'glib'
  depends_on 'icu4c' => :recommended

  # Needs newer fontconfig than XQuartz provides for pango
  depends_on 'fontconfig'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

end
