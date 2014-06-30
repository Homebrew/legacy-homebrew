require "formula"

class Suricata < Formula
  homepage "http://suricata-ids.org"
  url "http://www.openinfosecfoundation.org/download/suricata-2.0.tar.gz"
  sha1 "37819a0d6ecb7ebd4201bc32dec40824c145da98"

  bottle do
    sha1 "e696fc00b003d1ea19631e385f4dc84631eb2c64" => :mavericks
    sha1 "02691341316ab28d7bf1729f3ed5008170355f89" => :mountain_lion
    sha1 "3fcae2900b1f4070c48bb8d0720869b8364a9202" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "libyaml"
  depends_on "pcre"
  depends_on "geoip" => :optional

  # Use clang provided strl* functions. Reported upstream:
  # https://redmine.openinfosecfoundation.org/issues/1192
  patch :DATA

  def install
    libnet = Formula["libnet"]
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--with-libnet-includes=#{libnet.opt_include}",
            "--with-libnet-libs=#{libnet.opt_lib}"]

    if build.with? "geoip"
      geoip = Formula["geoip"]
      args << "--enable-geoip"
      args << "--with-libgeoip-includes=#{geoip.opt_include}"
      args << "--with-libgeoip-libs=#{geoip.opt_lib}"
    end

    system "./configure", *args
    system "make", "install"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index 32cb702..68ef842 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -266,7 +266,6 @@ am_suricata_OBJECTS = alert-debuglog.$(OBJEXT) alert-fastlog.$(OBJEXT) \
 	util-signal.$(OBJEXT) util-spm-bm.$(OBJEXT) \
 	util-spm-bs2bm.$(OBJEXT) util-spm-bs.$(OBJEXT) \
 	util-spm.$(OBJEXT) util-storage.$(OBJEXT) \
-	util-strlcatu.$(OBJEXT) util-strlcpyu.$(OBJEXT) \
 	util-syslog.$(OBJEXT) util-threshold-config.$(OBJEXT) \
 	util-time.$(OBJEXT) util-unittest.$(OBJEXT) \
 	util-unittest-helper.$(OBJEXT) util-affinity.$(OBJEXT) \
@@ -862,8 +861,6 @@ util-spm-bs2bm.c util-spm-bs2bm.h \
 util-spm-bs.c util-spm-bs.h \
 util-spm.c util-spm.h util-clock.h \
 util-storage.c util-storage.h \
-util-strlcatu.c \
-util-strlcpyu.c \
 util-syslog.c util-syslog.h \
 util-threshold-config.c util-threshold-config.h \
 util-time.c util-time.h \
@@ -1353,8 +1350,6 @@ distclean-compile:
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-spm-bs2bm.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-spm.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-storage.Po@am__quote@
-@AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-strlcatu.Po@am__quote@
-@AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-strlcpyu.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-syslog.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-threshold-config.Po@am__quote@
 @AMDEP_TRUE@@am__include@ @am__quote@./$(DEPDIR)/util-time.Po@am__quote@
diff --git a/src/suricata-common.h b/src/suricata-common.h
index 43c76c1..b6010f4 100644
--- a/src/suricata-common.h
+++ b/src/suricata-common.h
@@ -323,9 +323,6 @@ typedef enum PacketProfileDetectId_ {
 #include "util-path.h"
 #include "util-conf.h"
 
-size_t strlcat(char *, const char *src, size_t siz);
-size_t strlcpy(char *dst, const char *src, size_t siz);
-
 extern int coverage_unittests;
 extern int g_ut_modules;
 extern int g_ut_covered;
