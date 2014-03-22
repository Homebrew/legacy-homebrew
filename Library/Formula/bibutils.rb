require 'formula'

class Bibutils < Formula
  homepage 'http://sourceforge.net/p/bibutils/home/Bibutils/'
  url 'https://downloads.sourceforge.net/project/bibutils/bibutils_5.3_src.tgz'
  sha1 'd592ff4fea53dfc5440dc182204b5955fedb9ea2'

  #fix uint not being defined clang error
  patch :DATA

  def install
    system "./configure", "--install-dir", prefix
    system "make", "CC=#{ENV.cc}"

    cd 'bin' do
      bin.install %w{bib2xml ris2xml end2xml endx2xml med2xml isi2xml copac2xml
        biblatex2xml ebi2xml wordbib2xml xml2ads xml2bib xml2end xml2isi xml2ris
        xml2wordbib modsclean}
    end
  end
end

__END__
diff --git a/lib/biblatexin.c b/lib/biblatexin.c
index 41c51dc..8d6f57a 100644
--- a/lib/biblatexin.c
+++ b/lib/biblatexin.c
@@ -21,6 +21,8 @@
 #include "reftypes.h"
 #include "biblatexin.h"

+#include <sys/types.h>
+
 extern const char progname[];

 static list find    = { 0, 0, 0, NULL };
diff --git a/lib/bibtexin.c b/lib/bibtexin.c
index 5d97832..bce0847 100644
--- a/lib/bibtexin.c
+++ b/lib/bibtexin.c
@@ -21,6 +21,8 @@
 #include "reftypes.h"
 #include "bibtexin.h"

+#include <sys/types.h>
+
 static list find    = { 0, 0, 0, NULL };
 static list replace = { 0, 0, 0, NULL };
