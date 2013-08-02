require 'formula'

class Srecord < Formula
  homepage 'http://srecord.sourceforge.net/'
  url 'http://srecord.sourceforge.net/srecord-1.62.tar.gz'
  sha1 '144a5b802c86fe6408ccbe47b75867722034eb67'

  depends_on :libtool
  depends_on 'boost'
  depends_on 'libgcrypt'

  # Use OS X's pstopdf
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make install"
  end
end


__END__
--- /Makefile.in
+++ /Makefile.in
@@ -151,7 +151,7 @@

 etc/BUILDING.pdf: etc/BUILDING.man
	$(GROFF) -Tps -s -I. -t -man etc/BUILDING.man > etc/BUILDING.ps
-	ps2pdf etc/BUILDING.ps $@
+	pstopdf etc/BUILDING.ps $@
	rm etc/BUILDING.ps

 $(datarootdir)/doc/srecord/BUILDING.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -181,7 +181,7 @@
		etc/new.1.60.so etc/new.1.61.so etc/new.1.62.so etc/new.1.7.so \
		etc/new.1.8.so etc/new.1.9.so
	$(GROFF) -Tps -s -I. -t -man etc/README.man > etc/README.ps
-	ps2pdf etc/README.ps $@
+	pstopdf etc/README.ps $@
	rm etc/README.ps

 $(datarootdir)/doc/srecord/README.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -208,7 +208,7 @@
		etc/new.1.59.so etc/new.1.6.so etc/new.1.60.so etc/new.1.61.so \
		etc/new.1.62.so etc/new.1.7.so etc/new.1.8.so etc/new.1.9.so
	$(GROFF) -Tps -s -I. -t -man etc/change_log.man > etc/change_log.ps
-	ps2pdf etc/change_log.ps $@
+	pstopdf etc/change_log.ps $@
	rm etc/change_log.ps

 $(datarootdir)/doc/srecord/change_log.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -281,7 +281,7 @@
		man/man5/srec_ti_txt.5 man/man5/srec_trs80.5 \
		man/man5/srec_vmem.5 man/man5/srec_wilson.5
	$(GROFF) -Tps -s -I. -t -man etc/reference.man > etc/reference.ps
-	ps2pdf etc/reference.ps $@
+	pstopdf etc/reference.ps $@
	rm etc/reference.ps

 $(datarootdir)/doc/srecord/reference.pdf: .mkdir.__datarootdir__doc_srecord \
