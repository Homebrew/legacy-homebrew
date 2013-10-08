require 'formula'

class Recoll < Formula
  homepage 'http://www.recoll.org'
  url 'http://www.recoll.org/recoll-1.19.7.tar.gz'
  sha1 'f7521966f5d128867cca0cfb73d999b87eed6a9f'

  depends_on 'xapian'
  depends_on 'qt'

  def patches
    DATA
  end

  def install

    system "./configure", "--prefix=#{prefix}"
    system "make", "install" 
  end

  test do
    system "true"
  end
end

__END__
diff --git a/recollinstall.in b/recollinstall.in
index b21e849..36e3196 100755
--- a/recollinstall.in
+++ b/recollinstall.in
@@ -117,7 +117,7 @@ ${INSTALL} -m 0444 doc/man/recoll.conf.5  ${mandir}/man5/
 ${INSTALL} -m 0755 index/recollindex ${bindir} || exit 1
 ${STRIP} ${bindir}/recollindex
 
-${INSTALL} -m 0644 lib/librecoll.so.${RCLLIBVERSION} ${libdir}/recoll/ || exit 1
+#${INSTALL} -m 0644 lib/librecoll.so.${RCLLIBVERSION} ${libdir}/recoll/ || exit 1
 
 ${INSTALL} -m 0755 filters/rcl* ${datadir}/recoll/filters/ || exit 1
 for f in rclexecm.py rcllatinstops.zip;do
diff --git a/qtgui/rclmain_w.cpp b/qtgui/rclmain_w.cpp
index 785d413..df78715 100644
--- a/qtgui/rclmain_w.cpp
+++ b/qtgui/rclmain_w.cpp
@@ -233,51 +233,51 @@ void RclMain::init()
 	    this, SLOT(setStemLang(QAction*)));
     connect(preferencesMenu, SIGNAL(aboutToShow()),
 	    this, SLOT(adjustPrefsMenu()));
-    connect(fileExitAction, SIGNAL(activated() ), 
+    connect(fileExitAction, SIGNAL(triggered() ), 
 	    this, SLOT(fileExit() ) );
-    connect(fileToggleIndexingAction, SIGNAL(activated()), 
+    connect(fileToggleIndexingAction, SIGNAL(triggered()), 
 	    this, SLOT(toggleIndexing()));
-    connect(fileRebuildIndexAction, SIGNAL(activated()), 
+    connect(fileRebuildIndexAction, SIGNAL(triggered()), 
 	    this, SLOT(rebuildIndex()));
-    connect(fileEraseDocHistoryAction, SIGNAL(activated()), 
+    connect(fileEraseDocHistoryAction, SIGNAL(triggered()), 
 	    this, SLOT(eraseDocHistory()));
-    connect(fileEraseSearchHistoryAction, SIGNAL(activated()), 
+    connect(fileEraseSearchHistoryAction, SIGNAL(triggered()), 
 	    this, SLOT(eraseSearchHistory()));
-    connect(helpAbout_RecollAction, SIGNAL(activated()), 
+    connect(helpAbout_RecollAction, SIGNAL(triggered()), 
 	    this, SLOT(showAboutDialog()));
-    connect(showMissingHelpers_Action, SIGNAL(activated()), 
+    connect(showMissingHelpers_Action, SIGNAL(triggered()), 
 	    this, SLOT(showMissingHelpers()));
-    connect(showActiveTypes_Action, SIGNAL(activated()), 
+    connect(showActiveTypes_Action, SIGNAL(triggered()), 
 	    this, SLOT(showActiveTypes()));
-    connect(userManualAction, SIGNAL(activated()), 
+    connect(userManualAction, SIGNAL(triggered()), 
 	    this, SLOT(startManual()));
-    connect(toolsDoc_HistoryAction, SIGNAL(activated()), 
+    connect(toolsDoc_HistoryAction, SIGNAL(triggered()), 
 	    this, SLOT(showDocHistory()));
-    connect(toolsAdvanced_SearchAction, SIGNAL(activated()), 
+    connect(toolsAdvanced_SearchAction, SIGNAL(triggered()), 
 	    this, SLOT(showAdvSearchDialog()));
-    connect(toolsSpellAction, SIGNAL(activated()), 
+    connect(toolsSpellAction, SIGNAL(triggered()), 
 	    this, SLOT(showSpellDialog()));
-    connect(indexConfigAction, SIGNAL(activated()), 
+    connect(indexConfigAction, SIGNAL(triggered()), 
 	    this, SLOT(showIndexConfig()));
-    connect(indexScheduleAction, SIGNAL(activated()), 
+    connect(indexScheduleAction, SIGNAL(triggered()), 
 	    this, SLOT(showIndexSched()));
-    connect(queryPrefsAction, SIGNAL(activated()), 
+    connect(queryPrefsAction, SIGNAL(triggered()), 
 	    this, SLOT(showUIPrefs()));
-    connect(extIdxAction, SIGNAL(activated()), 
+    connect(extIdxAction, SIGNAL(triggered()), 
 	    this, SLOT(showExtIdxDialog()));
 
     if (prefs.catgToolBar && catgCMB)
 	connect(catgCMB, SIGNAL(activated(int)), 
 		this, SLOT(catgFilter(int)));
-    connect(toggleFullScreenAction, SIGNAL(activated()), 
+    connect(toggleFullScreenAction, SIGNAL(triggered()), 
             this, SLOT(toggleFullScreen()));
-    connect(actionShowQueryDetails, SIGNAL(activated()),
+    connect(actionShowQueryDetails, SIGNAL(triggered()),
 	    reslist, SLOT(showQueryDetails()));
     connect(periodictimer, SIGNAL(timeout()), 
 	    this, SLOT(periodic100()));
 
     restable->setRclMain(this, true);
-    connect(actionSaveResultsAsCSV, SIGNAL(activated()), 
+    connect(actionSaveResultsAsCSV, SIGNAL(triggered()), 
 	    restable, SLOT(saveAsCSV()));
     connect(this, SIGNAL(docSourceChanged(RefCntr<DocSequence>)),
 	    restable, SLOT(setDocSource(RefCntr<DocSequence>)));
@@ -309,11 +309,11 @@ void RclMain::init()
     reslist->setRclMain(this, true);
     connect(this, SIGNAL(docSourceChanged(RefCntr<DocSequence>)),
 	    reslist, SLOT(setDocSource(RefCntr<DocSequence>)));
-    connect(firstPageAction, SIGNAL(activated()), 
+    connect(firstPageAction, SIGNAL(triggered()), 
 	    reslist, SLOT(resultPageFirst()));
-    connect(prevPageAction, SIGNAL(activated()), 
+    connect(prevPageAction, SIGNAL(triggered()), 
 	    reslist, SLOT(resPageUpOrBack()));
-    connect(nextPageAction, SIGNAL(activated()),
+    connect(nextPageAction, SIGNAL(triggered()),
 	    reslist, SLOT(resPageDownOrNext()));
     connect(this, SIGNAL(searchReset()), 
 	    reslist, SLOT(resetList()));
