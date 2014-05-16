require 'formula'

class Suricata < Formula
  homepage 'http://suricata-ids.org'
  url 'http://www.openinfosecfoundation.org/download/suricata-1.4.7.tar.gz'
  sha1 '33eb752ee40e4377e78465d089c5113b7295ce2f'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build
  depends_on 'libmagic'
  depends_on 'libnet'
  depends_on 'libyaml'
  depends_on 'pcre'

  # Use clang provided strl* functions. Reported upstream:
  # https://redmine.openinfosecfoundation.org/issues/1192
  patch :DATA

  def install
    libnet = Formula["libnet"]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libnet-includes=#{libnet.opt_include}",
                          "--with-libnet-libs=#{libnet.opt_lib}"
    system "make", "install"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index 12dc173..d7aeb0e 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -292,7 +292,7 @@ am__suricata_SOURCES_DIST = alert-debuglog.c alert-debuglog.h \
 	util-runmodes.c util-runmodes.h util-signal.c util-signal.h \
 	util-spm-bm.c util-spm-bm.h util-spm-bs2bm.c util-spm-bs2bm.h \
 	util-spm-bs.c util-spm-bs.h util-spm.c util-spm.h util-clock.h \
-	util-strlcatu.c util-strlcpyu.c util-syslog.c util-syslog.h \
+	util-syslog.c util-syslog.h \
 	util-threshold-config.c util-threshold-config.h util-time.c \
 	util-time.h util-unittest.c util-unittest.h \
 	util-unittest-helper.c util-unittest-helper.h util-validate.h \
@@ -452,7 +452,6 @@ am_suricata_OBJECTS = alert-debuglog.$(OBJEXT) alert-fastlog.$(OBJEXT) \
 	util-runmodes.$(OBJEXT) util-signal.$(OBJEXT) \
 	util-spm-bm.$(OBJEXT) util-spm-bs2bm.$(OBJEXT) \
 	util-spm-bs.$(OBJEXT) util-spm.$(OBJEXT) \
-	util-strlcatu.$(OBJEXT) util-strlcpyu.$(OBJEXT) \
 	util-syslog.$(OBJEXT) util-threshold-config.$(OBJEXT) \
 	util-time.$(OBJEXT) util-unittest.$(OBJEXT) \
 	util-unittest-helper.$(OBJEXT) util-affinity.$(OBJEXT) \
@@ -1322,8 +1321,6 @@ distclean-compile:
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-spm-bs.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-spm-bs2bm.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-spm.Po@am__quote@
-@AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-strlcatu.Po@am__quote@
-@AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-strlcpyu.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-syslog.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-threshold-config.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-time.Po@am__quote@
diff --git a/src/suricata-common.h b/src/suricata-common.h
index 04543e1..cb7358d 100644
--- a/src/suricata-common.h
+++ b/src/suricata-common.h
@@ -304,8 +304,5 @@ typedef enum PacketProfileDetectId_ {
 #include "util-optimize.h"
 #include "util-path.h"
 
-size_t strlcat(char *, const char *src, size_t siz);
-size_t strlcpy(char *dst, const char *src, size_t siz);
-
 #endif /* __SURICATA_COMMON_H__ */
 
