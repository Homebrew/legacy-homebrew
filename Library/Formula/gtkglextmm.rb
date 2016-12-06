require 'formula'

class Gtkglextmm < Formula
  
  homepage 'http://projects.gnome.org/gtkglext'
  url 'http://downloads.sourceforge.net/gtkglext/gtkglextmm-1.2.0.tar.gz'
  md5 '6296b82bde8daa68452b2f0b4dadcb9e'

  depends_on 'pkg-config' => :build
  depends_on 'gtkglext'
  depends_on 'glibmm'
  
  def patches
    # fixes header include order, using patch from macports install: https://trac.macports.org/ticket/27059
    # upstream bug report made by original reporter: https://bugzilla.gnome.org/show_bug.cgi?id=636831
    { :p0 => "https://trac.macports.org/export/89836/trunk/dports/devel/gtkglextmm/files/patch-gtkglext_gtkmm_gl-widget.cc.diff"}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
