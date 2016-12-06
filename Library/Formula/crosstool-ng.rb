require 'formula'

class CrosstoolNg < Formula
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.14.1.tar.bz2'
  homepage 'http://crosstool-ng.org/'
  md5 '1e8e723df67c643ebdd529990607d5bf'

  depends_on 'wget' => :build
  depends_on 'gperf' => :build
  depends_on 'libtool' => :build
  depends_on 'binutils'

  # Patches the install-lib-kconfig section of Makefile.in because -D option
  # does not exist in Mac OS X install command.
  def patches; DATA; end

  def install
    ENV['READELF'] = "#{HOMEBREW_PREFIX}/bin/greadelf"
    ENV['OBJCOPY'] = "#{HOMEBREW_PREFIX}/bin/gobjcopy"
    ENV['OBJDUMP'] = "#{HOMEBREW_PREFIX}/bin/gobjdump"
    ENV['KBUILD_NO_NLS'] = '1'

    # GNU libtool is keg-only, so point configure to it
    libtool_prefix = Formula.factory('libtool').prefix

    # GNU gperf is keg-only
    gperf_bin = Formula.factory('gperf').bin
    inreplace "kconfig/Makefile", "@gperf", "@#{gperf_bin}/gperf"

    system "./configure", "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}",
                          "--with-libtool=#{libtool_prefix}/bin/glibtool",
                          "--with-libtoolize=#{libtool_prefix}/bin/glibtoolize"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/ct-ng version"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index b74a929..301ba3d 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -343,8 +343,9 @@ install-lib-samples: $(DESTDIR)$(libdir) install-lib-main
 KCONFIG_FILES := conf mconf nconf kconfig.mk
 install-lib-kconfig: $(DESTDIR)$(libdir) install-lib-main
 	@echo "  INST    'kconfig/'"
+	@mkdir -p $(DESTDIR)$(libdir)/kconfig
 	@for f in $(KCONFIG_FILES); do                                      \
-	    install -D "kconfig/$${f}" "$(DESTDIR)$(libdir)/kconfig/$${f}"; \
+	    install -m 644 "kconfig/$${f}" "$(DESTDIR)$(libdir)/kconfig/$${f}"; \
 	 done

 install-doc: $(DESTDIR)$(docdir)
diff --git a/kconfig/zconf.y b/kconfig/zconf.y
index b74a929..301ba3d 100644
--- a/kconfig/zconf.y
+++ a/kconfig/zconf.y
@@ -100,6 +100,8 @@
 } if_entry menu_entry choice_entry
 
 %{
+/* include sttdef to provide the offsetof macro */
+#include <stddef.h>
 /* Include zconf.hash.c here so it can see the token constants. */
 #include "zconf.hash.c"
 %}
