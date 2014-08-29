require 'formula'

class Evas < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Evas'
  url 'http://download.enlightenment.org/releases/evas-1.7.9.tar.gz'
  sha1 '5804cf35451f4e05185b6ae9103b0390c0dfed5d'

  option 'with-docs', 'Install development libraries/headers and HTML docs'

  depends_on 'pkg-config' => :build
  depends_on 'eina'
  depends_on 'eet'
  depends_on 'freetype'
  depends_on 'fontconfig'
  depends_on 'fribidi'
  depends_on 'harfbuzz'
  depends_on 'doxygen' if build.with? "docs"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--with-doxygen-file=#{HOMEBREW_PREFIX}/bin/doxygen" if build.with? "docs"

    system "./configure", *args

    system "make install"
    system "make install-doc" if build.with? "docs"
  end
end
