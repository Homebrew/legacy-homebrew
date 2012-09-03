require 'formula'

class Gtkglextmm < Formula
  homepage 'http://projects.gnome.org/gtkglext'
  url 'http://downloads.sourceforge.net/gtkglext/gtkglextmm-1.2.0.tar.gz'
  sha1 '5cd489e07517a88262cd6050f723227664e82996'

  depends_on 'pkg-config' => :build
  depends_on 'gtkglext'
  depends_on 'gtkmm'
  depends_on :x11

  # Fixes header include order, using patch from macports: https://trac.macports.org/ticket/27059
  # Upstream bug report: https://bugzilla.gnome.org/show_bug.cgi?id=636831
  def patches
    { :p0 => "https://trac.macports.org/export/89836/trunk/dports/devel/gtkglextmm/files/patch-gtkglext_gtkmm_gl-widget.cc.diff" }
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
