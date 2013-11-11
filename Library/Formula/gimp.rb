require 'formula'

class Gimp < Formula
  homepage 'http://www.gimp.org'
  url 'ftp://ftp.gimp.org/pub/gimp/v2.8/gimp-2.8.8.tar.bz2'
  sha1 'a97b93d608a8b0cccd0d97da63bee48d40cc4b35'
  version "2.8.8"

  option 'without-x', 'Build without X'

  depends_on 'pkg-config' => :build
  depends_on 'gettext' => :build
  depends_on 'intltool' => :build
  
  depends_on 'gegl'
  depends_on 'babl'
  depends_on 'fontconfig'
  if build.with? 'x'
    depends_on 'pango'
  else
    depends_on 'pango' => ['without-x']
  end
  depends_on 'glib'
  if build.with? 'x'
    depends_on 'gtk+'
  else
    depends_on 'gtk+' => ['without-x']
  end
  depends_on 'gdk-pixbuf'
  if build.with? 'x'
    depends_on 'cairo'
  else
    depends_on 'cairo' => ['without-x']
  end
  depends_on 'freetype'
  depends_on 'xz'
  depends_on 'lbzip2'

  if build.with? 'x'
    depends_on 'pygtk'
  else
    depends_on 'pygtk' => 'without-x'
  end

  #depends_on 'iso-codes'
  depends_on 'aalib'
  depends_on 'ghostscript'
  #depends_on 'lcms2'
  depends_on 'libpng'
  depends_on 'librsvg'
  depends_on 'libwmf'
  depends_on 'libexif'
  depends_on 'd-bus'

  def install
    system "./configure",
           "--prefix=#{prefix}",
           "--disable-glibtest"
    system "make", "install"
  end

  test do
    system "#{bin}/gimp", "--version"
  end
end