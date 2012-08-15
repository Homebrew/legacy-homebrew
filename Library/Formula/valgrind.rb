require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  # Valgrind 3.7.0 drops support for OS X 10.5
  if MACOS_VERSION >= 10.6
    url 'http://valgrind.org/downloads/valgrind-3.7.0.tar.bz2'
    md5 'a855fda56edf05614f099dca316d1775'
  else
    url "http://valgrind.org/downloads/valgrind-3.6.1.tar.bz2"
    md5 "2c3aa122498baecc9d69194057ca88f5"
  end

  skip_clean 'lib'

  def patches
    # For Xcode-only systems, we have to patch hard-coded paths, use xcrun and
    # add missing CFLAGS. See: https://bugs.kde.org/show_bug.cgi?id=295084
    DATA unless MacOS::CLT.installed?
  end

  def install
    ENV.remove_from_cflags "-mmacosx-version-min=#{MACOS_VERSION}"
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/valgrind", "ls", "-l"
  end
end

__END__
diff --git a/coregrind/Makefile.in b/coregrind/Makefile.in
index c2b6fc4..42e69f4 100644
--- a/coregrind/Makefile.in
+++ b/coregrind/Makefile.in
@@ -75,10 +75,10 @@ bin_PROGRAMS = valgrind$(EXEEXT) vgdb$(EXEEXT)
 @VGCONF_OS_IS_DARWIN_TRUE@        m_mach/vm_map.h
 
 @VGCONF_OS_IS_DARWIN_TRUE@am__append_7 = \
-@VGCONF_OS_IS_DARWIN_TRUE@	/usr/include/mach/mach_vm.defs \
-@VGCONF_OS_IS_DARWIN_TRUE@        /usr/include/mach/task.defs \
-@VGCONF_OS_IS_DARWIN_TRUE@        /usr/include/mach/thread_act.defs \
-@VGCONF_OS_IS_DARWIN_TRUE@        /usr/include/mach/vm_map.defs
+@VGCONF_OS_IS_DARWIN_TRUE@	$(SDKROOT)/usr/include/mach/mach_vm.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(SDKROOT)/usr/include/mach/task.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(SDKROOT)/usr/include/mach/thread_act.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(SDKROOT)/usr/include/mach/vm_map.defs
 
 @VGCONF_HAVE_PLATFORM_SEC_TRUE@am__append_8 = libcoregrind-@VGCONF_ARCH_SEC@-@VGCONF_OS@.a
 @VGCONF_HAVE_PLATFORM_SEC_TRUE@am__append_9 = libreplacemalloc_toolpreload-@VGCONF_ARCH_SEC@-@VGCONF_OS@.a
@@ -5667,9 +5667,9 @@ clean-noinst_DSYMS:
 $(abs_builddir)/m_mach: 
 	mkdir -p $@
 $(mach_user_srcs): $(mach_defs) $(abs_builddir)/m_mach
-	(cd m_mach && mig $(mach_defs))
+	(cd m_mach && xcrun mig $(mach_defs) )
 $(mach_hdrs): $(mach_defs) $(mach_user_srcs) $(abs_builddir)/m_mach
-	(cd m_mach && mig $(mach_defs))
+	(cd m_mach && xcrun mig $(mach_defs) )
 
 #----------------------------------------------------------------------------
 # General stuff
@@ -5686,7 +5686,7 @@ clean-local: clean-noinst_DSYMS
 
 install-exec-local: install-noinst_PROGRAMS install-noinst_DSYMS
 @VGCONF_OS_IS_DARWIN_TRUE@fixup_macho_loadcmds: fixup_macho_loadcmds.c
-@VGCONF_OS_IS_DARWIN_TRUE@	$(CC) -g -Wall -o fixup_macho_loadcmds fixup_macho_loadcmds.c
+@VGCONF_OS_IS_DARWIN_TRUE@	$(CC) -g -Wall -o fixup_macho_loadcmds fixup_macho_loadcmds.c $(CFLAGS)
 
 # Tell versions [3.59,3.63) of GNU make to not export all variables.
 # Otherwise a system limit (for SysV at least) may be exceeded.
--- a/coregrind/link_tool_exe_darwin.in
+++ b/coregrind/link_tool_exe_darwin.in
@@ -137,7 +137,7 @@ die "Can't find '-arch archstr' in command line"
 
 
 # build the command line
-my $cmd = "/usr/bin/ld";
+my $cmd = "xcrun ld";
 
 $cmd = "$cmd -static";
 $cmd = "$cmd -arch $archstr";

diff --git a/mpi/Makefile.in b/mpi/Makefile.in
index 23f0230..52a1c1e 100644
--- a/mpi/Makefile.in
+++ b/mpi/Makefile.in
@@ -368,7 +368,7 @@ EXTRA_DIST = \
        mpiwrap_type_test.c
 
 @VGCONF_OS_IS_DARWIN_TRUE@noinst_DSYMS = $(noinst_PROGRAMS)
-@VGCONF_OS_IS_DARWIN_TRUE@CFLAGS_MPI = -g -O -fno-omit-frame-pointer -Wall -dynamic
+@VGCONF_OS_IS_DARWIN_TRUE@CFLAGS_MPI = -g -O -fno-omit-frame-pointer -Wall -dynamic @CPPFLAGS@
 @VGCONF_OS_IS_LINUX_TRUE@CFLAGS_MPI = -g -O -fno-omit-frame-pointer -Wall -fpic
 @VGCONF_OS_IS_DARWIN_TRUE@LDFLAGS_MPI = -dynamic -dynamiclib -all_load
 @VGCONF_OS_IS_LINUX_TRUE@LDFLAGS_MPI = -fpic -shared
