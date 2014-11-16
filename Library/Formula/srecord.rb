require "formula"

class Srecord < Formula
  homepage "http://srecord.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/srecord/srecord/1.64/srecord-1.64.tar.gz"
  sha1 "f947751084f5837a1a7988cbfe5fcf3800958cb7"

  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "libgcrypt"

  # Use OS X's pstopdf
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make install"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index b669f1a..b03c002 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -151,7 +151,7 @@ the-default-target: all
 
 etc/BUILDING.pdf: etc/BUILDING.man
 	$(GROFF) -Tps -s -I. -t -man etc/BUILDING.man > etc/BUILDING.ps
-	ps2pdf etc/BUILDING.ps $@
+	pstopdf etc/BUILDING.ps $@
 	rm etc/BUILDING.ps
 
 $(datarootdir)/doc/srecord/BUILDING.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -181,7 +181,7 @@ etc/README.pdf: etc/README.man etc/new.1.1.so etc/new.1.10.so etc/new.1.11.so \
 		etc/new.1.60.so etc/new.1.61.so etc/new.1.62.so \
 		etc/new.1.63.so etc/new.1.7.so etc/new.1.8.so etc/new.1.9.so
 	$(GROFF) -Tps -s -I. -t -man etc/README.man > etc/README.ps
-	ps2pdf etc/README.ps $@
+	pstopdf etc/README.ps $@
 	rm etc/README.ps
 
 $(datarootdir)/doc/srecord/README.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -209,7 +209,7 @@ etc/change_log.pdf: etc/change_log.man etc/new.1.1.so etc/new.1.10.so \
 		etc/new.1.62.so etc/new.1.63.so etc/new.1.7.so etc/new.1.8.so \
 		etc/new.1.9.so
 	$(GROFF) -Tps -s -I. -t -man etc/change_log.man > etc/change_log.ps
-	ps2pdf etc/change_log.ps $@
+	pstopdf etc/change_log.ps $@
 	rm etc/change_log.ps
 
 $(datarootdir)/doc/srecord/change_log.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -283,7 +283,7 @@ etc/reference.pdf: etc/BUILDING.man etc/README.man etc/coding-style.so \
 		man/man5/srec_ti_txt.5 man/man5/srec_trs80.5 \
 		man/man5/srec_vmem.5 man/man5/srec_wilson.5
 	$(GROFF) -Tps -s -I. -t -man etc/reference.man > etc/reference.ps
-	ps2pdf etc/reference.ps $@
+	pstopdf etc/reference.ps $@
 	rm etc/reference.ps
 
 $(datarootdir)/doc/srecord/reference.pdf: .mkdir.__datarootdir__doc_srecord \
