require 'formula'

class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage 'http://gwyddion.net/'
  url 'http://gwyddion.net/download/2.40/gwyddion-2.40.tar.gz'
  sha1 '3e914985e5cde6303e2c842605014a9c66a1c030'

  bottle do
    sha1 "9e6ba00a543047c776d88ad1e3561247cdfacf05" => :yosemite
    sha1 "1eee93b2d89cffac4c224252ff5932b6697143c0" => :mavericks
    sha1 "3c621ed8e56d52a4502bc9b7fc1641a86988a94f" => :mountain_lion
  end

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
