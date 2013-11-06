require 'formula'

class Evas < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Evas'
  url 'http://download.enlightenment.org/releases/evas-1.7.8.tar.gz'
  sha1 'ce71de058896e80c8f1822d967a6dcee01a1c9ac'

  option 'with-docs', 'Install development libraries/headers and HTML docs'

  head do
    url 'http://svn.enlightenment.org/svn/e/trunk/evas/'

    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'eina'
  depends_on 'eet'
  depends_on 'freetype'
  depends_on 'fontconfig'
  depends_on 'fribidi'
  depends_on 'harfbuzz'
  depends_on 'doxygen' if build.include? 'with-docs'

  def install
    system "./autogen.sh" if build.head?

    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]

    args << "--with-doxygen-file=#{HOMEBREW_PREFIX}/bin/doxygen" if build.include? 'with-docs'

    system "./configure", *args

    system "make install"
    system "make install-doc" if build.include? 'with-docs'
  end
end
