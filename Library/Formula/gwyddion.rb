require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'http://gwyddion.net/download/2.38/gwyddion-2.38.tar.gz'
  sha1 '6fff92a9e98c11b0dae4333d8df3d4495b822e31'

  depends_on :x11 => :optional
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'libxml2'
  depends_on 'fftw'
  depends_on 'gtkglext'
  depends_on :python => :optional
  depends_on 'pygtk' if build.with? 'python'
  depends_on 'gtksourceview' if build.with? 'python'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{doc}"
    system "make install"
  end
end
