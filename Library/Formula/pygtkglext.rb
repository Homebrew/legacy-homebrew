require 'formula'

class Pygtkglext < Formula
  homepage 'http://projects.gnome.org/gtkglext/download.html#pygtkglext'
  url 'http://downloads.sourceforge.net/gtkglext/pygtkglext-1.1.0.tar.gz'
  md5 'dfbe2ceb05db9265a7d94b209fa8ad97'

  depends_on 'pkg-config' => :build
  depends_on 'pygtk'
  depends_on 'gtkglext'
  depends_on 'pygobject'

  def install
    ENV['PYGTK_CODEGEN'] = which 'pygobject-codegen-2.0'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # Test importing the modules
    mktemp do
      (Pathname.pwd+'test.py').write <<-EOS.undent
        import pygtk
        pygtk.require('2.0')
        import gtk.gtkgl
      EOS
      system "python test.py"
    end
  end
end
