require 'formula'

class Ace < Formula
  url 'http://download.dre.vanderbilt.edu/previous_versions/ACE-6.0.5.tar.bz2'
  homepage 'http://www.cse.wustl.edu/~schmidt/ACE.html'
  md5 '6958df8e3a672a549e651ec2287a3313'

  # XCode 4.1 an later have numeric typedefs that differ from ACE's,
  # that's why a patch is required. Probably a proper way to fix it is
  # using ./configure method of compilation, that detects such cases
  # automatically.
  if MacOS.xcode_version >= "4.1"
    def patches
      { :p0 => DATA }
    end
  end

  def install
    # ACE has two methods of compilation, "traditional" and ./configure.
    # The "traditional" method has consistently given better results
    # for the last 5 years, so although awkward to use on OSX, we use
    # it anyway.

    # First, we figure out the names of header files and make files
    # for this version of OSX.
    ver = %x[sw_vers -productVersion].chomp.split(".")
    ver = ver.slice(0).to_i*100 + ver.slice(1).to_i
    name = { 1002 => 'macosx', 1003 => 'macosx_panther',
             1004 => 'macosx_tiger', 1005 => 'macosx_leopard',
             1006 => 'macosx_snowleopard',
             1007 => 'macosx_lion' }[ver]
    makefile = "platform_#{name}.GNU"
    header = "config-" + name.sub('_','-') + ".h"

    # Now, we give those files the appropriate standard names.
    ln_sf header, "ace/config.h"
    ln_sf makefile, "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    root=Dir.pwd
    ENV['ACE_ROOT']=root
    ENV['DYLD_LIBRARY_PATH']="#{root}/ace:#{root}/lib"

    # Done! We go ahead and build.
    Dir.chdir "ace"
    system "make", "-f", "GNUmakefile.ACE", "INSTALL_PREFIX=#{prefix}",
       "LDFLAGS=", "DESTDIR=", "INST_DIR=/ace",
       "debug=0", "shared_libs=1", "static_libs=0", "install"
  end
end


__END__
--- ace/config-macosx-leopard-orig.h
+++ ace/config-macosx-leopard.h
@@ -226,4 +226,14 @@
 #error "Compiler must be upgraded, see http://developer.apple.com"
 #endif /* __APPLE_CC__ */
 
+// compiler supports numeric typedefs
+#define ACE_HAS_INT8_T
+#define ACE_HAS_UINT8_T
+#define ACE_HAS_INT16_T
+#define ACE_HAS_UINT16_T
+#define ACE_HAS_INT32_T
+#define ACE_HAS_UINT32_T
+#define ACE_HAS_INT64_T
+#define ACE_HAS_UINT64_T
+
 #endif /* ACE_CONFIG_MACOSX_LEOPARD_H */
