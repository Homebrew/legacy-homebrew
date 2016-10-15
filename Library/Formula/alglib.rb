require "formula"

class Alglib < Formula
  homepage "http://www.alglib.net"
  url "http://alglib.net/translator/re/alglib-2.6.0.cpp.zip"
  sha1 "5aae250153b079093b11ed8516d67a07cf9452f5"

  depends_on "qt"

  patch :DATA

  def install
    system "qmake", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end


__END__
diff -Naur cpp.orig/alglib.pro cpp.patch/alglib.pro
--- cpp.orig/alglib.pro	1970-01-01 01:00:00.000000000 +0100
+++ cpp.patch/alglib.pro	2014-09-11 15:57:13.000000000 +0200
@@ -0,0 +1,4 @@
+TEMPLATE = subdirs
+SUBDIRS = \
+    src
+
diff -Naur cpp.orig/src/src.pro cpp.patch/src/src.pro
--- cpp.orig/src/src.pro	1970-01-01 01:00:00.000000000 +0100
+++ cpp.patch/src/src.pro	2014-09-11 15:58:58.000000000 +0200
@@ -0,0 +1,242 @@
+
+isEmpty(PREFIX) {
+  PREFIX = /usr/local
+}
+
+CONFIG      += warn_on release
+QT      -= gui core
+LIBS    -= -lQtGui -lQtCore
+
+TARGET       = alglib
+VERSION      = 2.6.0
+TEMPLATE     = lib
+target.path = $$PREFIX/lib
+
+DEPENDPATH += .
+INCLUDEPATH += .
+
+OBJECTS_DIR  = ../tmp
+DESTDIR      = ../
+
+# Input
+HEADERS += ablas.h \
+           ablasf.h \
+           airyf.h \
+           ap.h \
+           apserv.h \
+           apvt.h \
+           autogk.h \
+           bdss.h \
+           bdsvd.h \
+           bessel.h \
+           betaf.h \
+           binomialdistr.h \
+           blas.h \
+           chebyshev.h \
+           chisquaredistr.h \
+           conv.h \
+           corr.h \
+           correlation.h \
+           correlationtests.h \
+           creflections.h \
+           dawson.h \
+           densesolver.h \
+           descriptivestatistics.h \
+           dforest.h \
+           elliptic.h \
+           estnorm.h \
+           evd.h \
+           expintegrals.h \
+           fdistr.h \
+           fft.h \
+           fht.h \
+           fresnel.h \
+           ftbase.h \
+           gammafunc.h \
+           gkq.h \
+           gq.h \
+           hblas.h \
+           hermite.h \
+           hqrnd.h \
+           hsschur.h \
+           ialglib.h \
+           ibetaf.h \
+           idwint.h \
+           igammaf.h \
+           inverseupdate.h \
+           jacobianelliptic.h \
+           jarquebera.h \
+           kmeans.h \
+           laguerre.h \
+           lda.h \
+           ldlt.h \
+           legendre.h \
+           linmin.h \
+           linreg.h \
+           logit.h \
+           lsfit.h \
+           mannwhitneyu.h \
+           matdet.h \
+           matgen.h \
+           matinv.h \
+           minasa.h \
+           mincg.h \
+           minlbfgs.h \
+           minlm.h \
+           mlpbase.h \
+           mlpe.h \
+           mlptrain.h \
+           nearestneighbor.h \
+           nearunityunit.h \
+           normaldistr.h \
+           odesolver.h \
+           ortfac.h \
+           pca.h \
+           poissondistr.h \
+           polint.h \
+           psif.h \
+           pspline.h \
+           ratint.h \
+           ratinterpolation.h \
+           rcond.h \
+           reflections.h \
+           rotations.h \
+           safesolve.h \
+           sblas.h \
+           schur.h \
+           sdet.h \
+           sinverse.h \
+           spdgevd.h \
+           spline1d.h \
+           spline2d.h \
+           spline3.h \
+           srcond.h \
+           ssolve.h \
+           stdafx.h \
+           stest.h \
+           studenttdistr.h \
+           studentttests.h \
+           svd.h \
+           trfac.h \
+           trigintegrals.h \
+           trlinsolve.h \
+           tsort.h \
+           variancetests.h \
+           wsr.h \
+           xblas.h
+SOURCES += ablas.cpp \
+           ablasf.cpp \
+           airyf.cpp \
+           ap.cpp \
+           apserv.cpp \
+           autogk.cpp \
+           bdss.cpp \
+           bdsvd.cpp \
+           bessel.cpp \
+           betaf.cpp \
+           binomialdistr.cpp \
+           blas.cpp \
+           chebyshev.cpp \
+           chisquaredistr.cpp \
+           conv.cpp \
+           corr.cpp \
+           correlation.cpp \
+           correlationtests.cpp \
+           creflections.cpp \
+           dawson.cpp \
+           densesolver.cpp \
+           descriptivestatistics.cpp \
+           dforest.cpp \
+           elliptic.cpp \
+           estnorm.cpp \
+           evd.cpp \
+           expintegrals.cpp \
+           fdistr.cpp \
+           fft.cpp \
+           fht.cpp \
+           fresnel.cpp \
+           ftbase.cpp \
+           gammafunc.cpp \
+           gkq.cpp \
+           gq.cpp \
+           hblas.cpp \
+           hermite.cpp \
+           hqrnd.cpp \
+           hsschur.cpp \
+           ialglib.cpp \
+           ibetaf.cpp \
+           idwint.cpp \
+           igammaf.cpp \
+           inverseupdate.cpp \
+           jacobianelliptic.cpp \
+           jarquebera.cpp \
+           kmeans.cpp \
+           laguerre.cpp \
+           lda.cpp \
+           ldlt.cpp \
+           legendre.cpp \
+           linmin.cpp \
+           linreg.cpp \
+           logit.cpp \
+           lsfit.cpp \
+           mannwhitneyu.cpp \
+           matdet.cpp \
+           matgen.cpp \
+           matinv.cpp \
+           minasa.cpp \
+           mincg.cpp \
+           minlbfgs.cpp \
+           minlm.cpp \
+           mlpbase.cpp \
+           mlpe.cpp \
+           mlptrain.cpp \
+           nearestneighbor.cpp \
+           nearunityunit.cpp \
+           normaldistr.cpp \
+           odesolver.cpp \
+           ortfac.cpp \
+           pca.cpp \
+           poissondistr.cpp \
+           polint.cpp \
+           psif.cpp \
+           pspline.cpp \
+           ratint.cpp \
+           ratinterpolation.cpp \
+           rcond.cpp \
+           reflections.cpp \
+           rotations.cpp \
+           safesolve.cpp \
+           sblas.cpp \
+           schur.cpp \
+           sdet.cpp \
+           sinverse.cpp \
+           spdgevd.cpp \
+           spline1d.cpp \
+           spline2d.cpp \
+           spline3.cpp \
+           srcond.cpp \
+           ssolve.cpp \
+           stest.cpp \
+           studenttdistr.cpp \
+           studentttests.cpp \
+           svd.cpp \
+           trfac.cpp \
+           trigintegrals.cpp \
+           trlinsolve.cpp \
+           tsort.cpp \
+           variancetests.cpp \
+           wsr.cpp \
+           xblas.cpp
+
+
+header_files.files = $$HEADERS
+header_files.path = $$PREFIX/include/alglib
+
+INSTALLS += target
+INSTALLS += header_files
+
+CONFIG     += create_pc create_prl no_install_prl
+QMAKE_PKGCONFIG_LIBDIR = $$PREFIX/lib/
+QMAKE_PKGCONFIG_INCDIR = $$PREFIX/include/alglib
+QMAKE_PKGCONFIG_CFLAGS = -I$$PREFIX/include/
+QMAKE_PKGCONFIG_DESTDIR = pkgconfig
\ No newline at end of file
