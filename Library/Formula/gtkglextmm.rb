require 'formula'

class Gtkglextmm < Formula
  homepage 'http://projects.gnome.org/gtkglext'
  url 'http://downloads.sourceforge.net/gtkglext/gtkglextmm-1.2.0.tar.gz'
  md5 '6296b82bde8daa68452b2f0b4dadcb9e'

  depends_on 'gtkglext'
  depends_on 'glibmm'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def patches
    # fixes include order, using patch from macports install: https://trac.macports.org/ticket/27059
    # upstream bug report made by original reporter: https://bugzilla.gnome.org/show_bug.cgi?id=636831
    { :p0 => "https://raw.github.com/gist/1810490/47f20662cce2cec044b9211c062365fe74ce381c/patch%20for%20gtkglextmm"}
  end

end
