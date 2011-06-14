require 'formula'

class Seccure < Formula
  url 'http://point-at-infinity.org/seccure/seccure-0.4.tar.gz'
  homepage 'http://point-at-infinity.org/seccure/'
  md5 'b9fb2f24224b90aadcb2e42e41e50e6f'

  # depends_on 'cmake'
	depends_on 'libgcrypt'
	
	def patches
		# The original makefile had a poor use of DESTDIR
		DATA
	end

  def install
    # system "cmake . #{std_cmake_parameters}"
		ENV["DESTDIR"] = '/usr/local'
    system "make install"
  end
end

__END__
diff -u seccure-0.4/Makefile seccure-0.4-fixed/Makefile
--- seccure-0.4/Makefile	2009-04-09 08:42:50.000000000 -0400
+++ seccure-0.4-fixed/Makefile	2011-06-14 07:19:00.000000000 -0400
@@ -8,15 +8,15 @@
 doc: seccure.1 seccure.1.html
 
 install: default
-	install -m0755 seccure-key $(DESTDIR)/usr/bin
-	ln -f $(DESTDIR)/usr/bin/seccure-key $(DESTDIR)/usr/bin/seccure-encrypt
-	ln -f $(DESTDIR)/usr/bin/seccure-key $(DESTDIR)/usr/bin/seccure-decrypt
-	ln -f $(DESTDIR)/usr/bin/seccure-key $(DESTDIR)/usr/bin/seccure-sign
-	ln -f $(DESTDIR)/usr/bin/seccure-key $(DESTDIR)/usr/bin/seccure-verify
-	ln -f $(DESTDIR)/usr/bin/seccure-key $(DESTDIR)/usr/bin/seccure-signcrypt
-	ln -f $(DESTDIR)/usr/bin/seccure-key $(DESTDIR)/usr/bin/seccure-veridec
-	ln -f $(DESTDIR)/usr/bin/seccure-key $(DESTDIR)/usr/bin/seccure-dh
-	install -m0644 seccure.1 $(DESTDIR)/usr/share/man/man1
+	install -m0755 seccure-key $(DESTDIR)/bin
+	ln -f $(DESTDIR)/bin/seccure-key $(DESTDIR)/bin/seccure-encrypt
+	ln -f $(DESTDIR)/bin/seccure-key $(DESTDIR)/bin/seccure-decrypt
+	ln -f $(DESTDIR)/bin/seccure-key $(DESTDIR)/bin/seccure-sign
+	ln -f $(DESTDIR)/bin/seccure-key $(DESTDIR)/bin/seccure-verify
+	ln -f $(DESTDIR)/bin/seccure-key $(DESTDIR)/bin/seccure-signcrypt
+	ln -f $(DESTDIR)/bin/seccure-key $(DESTDIR)/bin/seccure-veridec
+	ln -f $(DESTDIR)/bin/seccure-key $(DESTDIR)/bin/seccure-dh
+	install -m0644 seccure.1 $(DESTDIR)/share/man/man1
 
 clean:
 	rm -f *.o *~ seccure-key seccure-encrypt seccure-decrypt seccure-sign \
