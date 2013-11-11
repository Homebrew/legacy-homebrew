require 'formula'

class Gimp < Formula
  homepage 'http://www.gimp.org'
  url 'ftp://ftp.gimp.org/pub/gimp/v2.8/gimp-2.8.8.tar.bz2'
  sha1 'a97b93d608a8b0cccd0d97da63bee48d40cc4b35'
  #version "2.8.8"

  option 'without-x', 'Build without X'

  depends_on 'pkg-config' => :build
  depends_on 'gegl'
  depends_on 'babl'
  depends_on 'fontconfig'
  if build.with? 'x'
    depends_on 'pango'
  else
    depends_on 'pango' => ['without-x']
  end
  depends_on 'glib'
  if bild.with? 'x'
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
  depends_on 'gettext'

  def install
    system "./autogen.sh", " --prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/program", "--version"
  end
end
