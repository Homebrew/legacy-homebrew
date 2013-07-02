require 'base_kde_formula'

class Strigi < BaseKdeFormula
  homepage 'http://strigi.sourceforge.net/'
  url 'http://www.vandenoever.info/software/strigi/strigi-0.7.8.tar.bz2'
  sha1 '7250fb15109d33b0c49995a2cc3513ba7d937882'

  depends_on 'clucene'
  #depends_on 'ffmpeg'
  depends_on 'exiv2' => :optional

  def extra_cmake_args
    "-DENABLE_EXPAT:BOOL=ON -DENABLE_DBUS:BOOL=OFF"
  end

  def patches; DATA; end

  def install
    ENV['CLUCENE_HOME'] = HOMEBREW_PREFIX
    ENV['EXPAT_HOME'] = '/usr/'

    default_install
  end
end

__END__
diff -u a/strigiclient/lib/searchclient/qtdbus/strigitypes.h.orig b/strigiclient/lib/searchclient/qtdbus/strigitypes.h
--- a/strigiclient/lib/searchclient/qtdbus/strigitypes.h.orig	2013-04-08 11:12:23.000000000 -0400
+++ b/strigiclient/lib/searchclient/qtdbus/strigitypes.h	2013-04-08 11:12:42.000000000 -0400
@@ -24,7 +24,6 @@
 #include <QtCore/QPair>
 #include <QtCore/QVector>
 #include <QtCore/QMetaType>
-#include <QtDBus/QtDBus>

 typedef QVector<QList<QVariant> > VariantListVector;
 Q_DECLARE_METATYPE(VariantListVector)