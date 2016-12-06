require 'formula'

class LibqxtHttpDownloadStrategy < CurlDownloadStrategy
  def stage
    # need to convert newlines or patch chokes
    safe_system '/usr/bin/unzip', '-aaq', @tarball_path
    safe_system '/usr/bin/unzip', '-boq', @tarball_path, '*.png'
    chdir
  end
end

class Libqxt < Formula
  url 'http://dev.libqxt.org/libqxt/get/v0.6.1.zip',
         :using => LibqxtHttpDownloadStrategy
  homepage 'http://libqxt.org'
  md5 '91fb2f761bac17c6dc93882084292425'

  # bitbucket.org returns a full HTML page if using the default User-Agent
  HOMEBREW_USER_AGENT.replace("Wget")

  depends_on 'qt'
  depends_on 'berkeley-db' => :optional

  def patches
    # This patch, not yet introduced in an official release as of 0.6.1,
    # allows building against Qt > 4.6.1 and SL, for details see:
    # https://bitbucket.org/libqxt/libqxt/issue/50/install-issue-qxt-060-on-mac-os-x-1063
    ["https://bitbucket.org/libqxt/libqxt/changeset/bf1b3772b917/raw/libqxt-bf1b3772b917.diff",
    # Fixes installation for not writing outside Keg and broken docs
    DATA]
  end

  def install
    system "./configure", "-release", "-prefix", "#{prefix}",
                          "-libdir", "#{lib}",
                          "-featuredir", "#{prefix}/mkspecs/features"
    system "make all"
    system "make docs"
    system "make install"
    system "cp", "-a", "examples", "#{prefix}"
  end
end
__END__
diff --git a/doc/doc.pri b/doc/doc.pri
index 1de8bfe..7563b4f 100644
--- a/doc/doc.pri
+++ b/doc/doc.pri
@@ -28,10 +28,15 @@ docs.depends = adp_docs
 QMAKE_EXTRA_TARGETS += adp_docs docs
 
 htmldocs.files = $$QXT_BUILD_TREE/doc/html/*
-htmldocs.path = $$QXT_INSTALL_DOCS
+htmldocs.path = $$QXT_INSTALL_DOCS/html
 htmldocs.CONFIG += no_check_exist
 
+htmlimages.files = $$QXT_BUILD_TREE/doc/html/images/*
+htmlimages.path = $$QXT_INSTALL_DOCS/html/images
+htmlimages.CONFIG += no_check_exist
+
 INSTALLS += htmldocs
+INSTALLS += htmlimages
 
 exists( $$[QT_INSTALL_BINS]/qhelpgenerator) {
     QHELPGENERATOR = $$[QT_INSTALL_BINS]/qhelpgenerator
diff --git a/src/designer/designer.pro b/src/designer/designer.pro
index 8e8e619..a490119 100644
--- a/src/designer/designer.pro
+++ b/src/designer/designer.pro
@@ -9,4 +9,5 @@ include(../qxtbase.pri)
 
 CONFIG          += designer plugin
 target.path      = $$[QT_INSTALL_PLUGINS]/designer
+target.path      = $${QXT_INSTALL_LIBS}/../plugins/designer
 INSTALLS         = target

