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
    system "make", "AR=ar" # have to set AR or valgrind picks cc (WTF?)
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
+@VGCONF_OS_IS_DARWIN_TRUE@	$(HOMEBREW_SDKROOT)/usr/include/mach/mach_vm.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(HOMEBREW_SDKROOT)/usr/include/mach/task.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(HOMEBREW_SDKROOT)/usr/include/mach/thread_act.defs \
+@VGCONF_OS_IS_DARWIN_TRUE@        $(HOMEBREW_SDKROOT)/usr/include/mach/vm_map.defs

 @VGCONF_HAVE_PLATFORM_SEC_TRUE@am__append_11 = libcoregrind-@VGCONF_ARCH_SEC@-@VGCONF_OS@.a
 @ENABLE_LINUX_TICKET_LOCK_PRIMARY_TRUE@am__append_12 = \
diff --git a/coregrind/link_tool_exe_darwin.in b/coregrind/link_tool_exe_darwin.in
index bf483a9..8474346 100644
--- a/coregrind/link_tool_exe_darwin.in
+++ b/coregrind/link_tool_exe_darwin.in
@@ -138,7 +138,7 @@ die "Can't find '-arch archstr' in command line"


 # build the command line
-my $cmd = "/usr/bin/ld";
+my $cmd = "ld";

 $cmd = "$cmd -static";
