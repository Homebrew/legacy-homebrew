require 'formula'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'

  # Valgrind 3.7.0 drops support for OS X 10.5
  if MacOS.version >= 10.6
    url 'http://valgrind.org/downloads/valgrind-3.8.0.tar.bz2'
    sha1 '074b09e99b09634f1efa6f7f0f87c7a541fb9b0d'
  else
    url "http://valgrind.org/downloads/valgrind-3.6.1.tar.bz2"
    md5 "2c3aa122498baecc9d69194057ca88f5"
  end

  head 'svn://svn.valgrind.org/valgrind/trunk'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  skip_clean 'lib'

  def patches
    # For Xcode-only systems, we have to patch hard-coded paths, use xcrun and
    # add missing CFLAGS. See: https://bugs.kde.org/show_bug.cgi?id=295084
    DATA
  end unless MacOS::CLT.installed?

  def install
    # avoid undefined symbol __bzero
    ENV.remove_from_cflags "-mmacosx-version-min=#{MacOS.version}"

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    if MacOS.prefer_64_bit?
      args << "--enable-only64bit" << "--build=amd64-darwin"
    else
      args << "--enable-only32bit"
    end

    system "./autogen.sh" if build.head?
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
index d62cf92..477b069 100644
--- a/coregrind/Makefile.in
+++ b/coregrind/Makefile.in
@@ -82,10 +82,10 @@ bin_PROGRAMS = valgrind$(EXEEXT) vgdb$(EXEEXT)
 @VGCONF_OS_IS_DARWIN_TRUE@        m_mach/vm_map.h
 
 @VGCONF_OS_IS_DARWIN_TRUE@am__append_10 = \
-@VGCONF_OS_IS_DARWIN_TRUE@	/usr/include/mach/mach_vm.defs \
-@VGCONF_OS_IS_DARWIN_TRUE@        /usr/include/mach/task.defs \
-@VGCONF_OS_IS_DARWIN_TRUE@        /usr/include/mach/thread_act.defs \
-@VGCONF_OS_IS_DARWIN_TRUE@        /usr/include/mach/vm_map.defs
+@VGCONF_OS_IS_DARWIN_TRUE@	$(SDKROOT)/usr/include/mach/mach_vm.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(SDKROOT)/usr/include/mach/task.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(SDKROOT)/usr/include/mach/thread_act.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(SDKROOT)/usr/include/mach/vm_map.defs
 
 @VGCONF_HAVE_PLATFORM_SEC_TRUE@am__append_11 = libcoregrind-@VGCONF_ARCH_SEC@-@VGCONF_OS@.a
 @ENABLE_LINUX_TICKET_LOCK_PRIMARY_TRUE@am__append_12 = \
@@ -6058,9 +6058,9 @@ clean-noinst_DSYMS:
 $(abs_builddir)/m_mach: 
 	mkdir -p $@
 $(mach_user_srcs): $(mach_defs) $(abs_builddir)/m_mach
-	(cd m_mach && mig $(mach_defs))
+	(cd m_mach && xcrun mig $(mach_defs))
 $(mach_hdrs): $(mach_defs) $(mach_user_srcs) $(abs_builddir)/m_mach
-	(cd m_mach && mig $(mach_defs))
+	(cd m_mach && xcrun mig $(mach_defs))
 
 #----------------------------------------------------------------------------
 # General stuff
@@ -6077,7 +6077,7 @@ clean-local: clean-noinst_DSYMS
 
 install-exec-local: install-noinst_PROGRAMS install-noinst_DSYMS
 @VGCONF_OS_IS_DARWIN_TRUE@fixup_macho_loadcmds: fixup_macho_loadcmds.c
-@VGCONF_OS_IS_DARWIN_TRUE@	$(CC) -g -Wall -o fixup_macho_loadcmds fixup_macho_loadcmds.c
+@VGCONF_OS_IS_DARWIN_TRUE@	$(CC) -g -Wall -o fixup_macho_loadcmds fixup_macho_loadcmds.c $(CFLAGS)
 
 # Tell versions [3.59,3.63) of GNU make to not export all variables.
 # Otherwise a system limit (for SysV at least) may be exceeded.
diff --git a/coregrind/link_tool_exe_darwin.in b/coregrind/link_tool_exe_darwin.in
index bf483a9..8474346 100644
--- a/coregrind/link_tool_exe_darwin.in
+++ b/coregrind/link_tool_exe_darwin.in
@@ -138,7 +138,7 @@ die "Can't find '-arch archstr' in command line"
 
 
 # build the command line
-my $cmd = "/usr/bin/ld";
+my $cmd = "xcrun ld";
 
 $cmd = "$cmd -static";
 
diff --git a/mpi/Makefile.in b/mpi/Makefile.in
index 177b408..45128e7 100644
--- a/mpi/Makefile.in
+++ b/mpi/Makefile.in
@@ -377,7 +377,7 @@ EXTRA_DIST = \
 @BUILD_MPIWRAP_PRI_TRUE@libmpiwrap_@VGCONF_ARCH_PRI@_@VGCONF_OS@_so_SOURCES = libmpiwrap.c
 @BUILD_MPIWRAP_PRI_TRUE@libmpiwrap_@VGCONF_ARCH_PRI@_@VGCONF_OS@_so_CPPFLAGS = -I../include
 @BUILD_MPIWRAP_PRI_TRUE@libmpiwrap_@VGCONF_ARCH_PRI@_@VGCONF_OS@_so_CFLAGS = \
-@BUILD_MPIWRAP_PRI_TRUE@	$(CFLAGS_MPI) $(MPI_FLAG_M3264_PRI)
+@BUILD_MPIWRAP_PRI_TRUE@	$(CFLAGS_MPI) $(MPI_FLAG_M3264_PRI) @CPPFLAGS@
 
 @BUILD_MPIWRAP_PRI_TRUE@libmpiwrap_@VGCONF_ARCH_PRI@_@VGCONF_OS@_so_LDFLAGS = $(LDFLAGS_MPI)
 @BUILD_MPIWRAP_SEC_TRUE@libmpiwrap_@VGCONF_ARCH_SEC@_@VGCONF_OS@_so_SOURCES = libmpiwrap.c
