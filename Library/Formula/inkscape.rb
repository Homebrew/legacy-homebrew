require 'formula'

class Inkscape < Formula
  homepage 'http://inkscape.org/'
  url 'https://downloads.sourceforge.net/project/inkscape/inkscape/0.48.5/inkscape-0.48.5.tar.gz'
  sha1 'e14789da0f6b5b84ef26f6759e295bc4be7bd34d'

  bottle do
    revision 1
    sha1 "ad338136463ee2a73dc0922e4f059bd1dc3a8a10" => :mavericks
    sha1 "8160eb07157e6b969b50d9ff15d737d0f2365089" => :mountain_lion
    sha1 "866814f911ba37e2214c8a983e91c0bdc668736e" => :lion
  end

  stable do
    # boost 1.56 compatibility
    # https://bugs.launchpad.net/inkscape/+bug/1357411
    patch :p0, :DATA
  end

  head do
    url 'lp:inkscape/0.48.x', :using => :bzr

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'boost-build' => :build
  depends_on 'gettext'
  depends_on 'bdw-gc'
  depends_on 'glibmm'
  depends_on 'gtkmm'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'popt'
  depends_on 'little-cms'
  depends_on 'cairomm'
  depends_on 'pango'
  depends_on :x11
  depends_on 'poppler' => :optional
  depends_on 'hicolor-icon-theme'

  needs :cxx11

  fails_with :clang do
    cause "inkscape's dependencies will be built with libstdc++ and fail to link."
  end if MacOS.version < :mavericks

  def install
    ENV.cxx11

    system "./autogen.sh" if build.head?

    args = [ "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--enable-lcms" ]
    args << "--disable-poppler-cairo" if build.without? "poppler"
    system "./configure", *args

    system "make install"
  end

  test do
    system "#{bin}/inkscape", "-V"
  end
end
__END__
=== modified file 'src/object-snapper.cpp'
--- src/object-snapper.cpp	2010-07-19 06:51:04 +0000
+++ src/object-snapper.cpp	2014-08-15 15:43:28 +0000
@@ -561,7 +561,7 @@
                         // When it's within snapping range, then return it
                         // (within snapping range == between p_min_on_cl and p_max_on_cl == 0 < ta < 1)
                         Geom::Coord dist = Geom::L2(_snapmanager->getDesktop()->dt2doc(p_proj_on_cl) - p_inters);
-                        SnappedPoint s(_snapmanager->getDesktop()->doc2dt(p_inters), p.getSourceType(), p.getSourceNum(), k->target_type, dist, getSnapperTolerance(), getSnapperAlwaysSnap(), true, k->target_bbox);
+                        SnappedPoint s(_snapmanager->getDesktop()->doc2dt(p_inters), p.getSourceType(), p.getSourceNum(), k->target_type, dist, getSnapperTolerance(), getSnapperAlwaysSnap(), true, false, k->target_bbox);
                         sc.points.push_back(s);
                     }
                 }
