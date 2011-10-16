require 'formula'
require 'utils'

class Valgrind < Formula
  homepage 'http://www.valgrind.org/'
  head 'svn://svn.valgrind.org/valgrind/trunk'
  url "http://valgrind.org/downloads/valgrind-3.6.1.tar.bz2"
  md5 "2c3aa122498baecc9d69194057ca88f5"

  depends_on 'pkg-config' => :build

  fails_with_llvm "Makes applications segfault on startup", :build => 2326

  skip_clean 'lib'

  def patches
    # Xcode 4 fix from upstream r11686
    # https://bugs.kde.org/show_bug.cgi?id=267997
    {:p0 => DATA}
  end if MacOS.xcode_version >= "4.0" and not ARGV.build_head?

  def install
    if MacOS.lion? and not ARGV.build_head?
      onoe <<-EOS.undent
        The current stable version of Valgrind (3.6.1) does not work on Lion.
        You may try `brew install valgrind --HEAD` to install an unstable
        version that has some Lion support.
      EOS
      exit 1
    end

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-only64bit" << "--build=amd64-darwin" if MacOS.prefer_64_bit?

    # Remove when Xcode 4 fix is removed
    system "autoreconf -ivf" if MacOS.xcode_version >= "4.0" and not ARGV.build_head?

    system "./autogen.sh" if ARGV.build_head?

    system "./configure", *args
    system "make install"
  end
end

__END__
Index: coregrind/fixup_macho_loadcmds.c
===================================================================
--- coregrind/fixup_macho_loadcmds.c	(revision 0)
+++ coregrind/fixup_macho_loadcmds.c	(revision 11686)
@@ -0,0 +1,605 @@
+
+/* Derived from Valgrind sources, coregrind/m_debuginfo/readmacho.c.
+   GPL 2+ therefore.
+
+   Can be compiled as either a 32- or 64-bit program (doesn't matter).
+*/
+
+/* What does this program do?  In short it postprocesses tool
+   executables on MacOSX, after linking using /usr/bin/ld.  This is so
+   as to work around a bug in the linker on Xcode 4.0.0 and Xcode
+   4.0.1.  Xcode versions prior to 4.0.0 are unaffected.
+
+   The tracking bug is https://bugs.kde.org/show_bug.cgi?id=267997
+
+   The bug causes 64-bit tool executables to segfault at startup,
+   because:
+
+   Comparing the MachO load commands vs a (working) tool executable
+   that was created by Xcode 3.2.x, it appears that the new linker has
+   partially ignored the build system's request to place the tool
+   executable's stack at a non standard location.  The build system
+   tells the linker "-stack_addr 0x134000000 -stack_size 0x800000".
+
+   With the Xcode 3.2 linker those flags produce two results:
+
+   (1) A load command to allocate the stack at the said location:
+          Load command 3
+                cmd LC_SEGMENT_64
+            cmdsize 72
+            segname __UNIXSTACK
+             vmaddr 0x0000000133800000
+             vmsize 0x0000000000800000
+            fileoff 2285568
+           filesize 0
+            maxprot 0x00000007
+           initprot 0x00000003
+             nsects 0
+              flags 0x0
+
+   (2) A request (in LC_UNIXTHREAD) to set %rsp to the correct value
+       at process startup, 0x134000000.
+
+   With Xcode 4.0.1, (1) is missing but (2) is still present.  The
+   tool executable therefore starts up with %rsp pointing to unmapped
+   memory and faults almost instantly.
+
+   The workaround implemented by this program is documented in comment
+   8 of bug 267997, viz:
+
+   One really sick workaround is to observe that the executables
+   contain a redundant MachO load command:
+
+      Load command 2
+            cmd LC_SEGMENT_64
+        cmdsize 72
+        segname __LINKEDIT
+         vmaddr 0x0000000138dea000
+         vmsize 0x00000000000ad000
+        fileoff 2658304
+       filesize 705632
+        maxprot 0x00000007
+       initprot 0x00000001
+         nsects 0
+          flags 0x0
+
+   The described section presumably contains information intended for
+   the dynamic linker, but is irrelevant because this is a statically
+   linked executable.  Hence it might be possible to postprocess the
+   executables after linking, to overwrite this entry with the
+   information that would have been in the missing __UNIXSTACK entry.
+   I tried this by hand (with a binary editor) earlier and got
+   something that worked.
+*/
+
+#define DEBUGPRINTING 0
+
+#include <assert.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+
+#undef PLAT_x86_darwin
+#undef PLAT_amd64_darwin
+
+#if defined(__APPLE__) && defined(__i386__)
+#  define PLAT_x86_darwin 1
+#elif defined(__APPLE__) && defined(__x86_64__)
+#  define PLAT_amd64_darwin 1
+#else
+#  error "Can't be compiled on this platform"
+#endif
+
+#include <mach-o/loader.h>
+#include <mach-o/nlist.h>
+#include <mach-o/fat.h>
+#include <mach/i386/thread_status.h>
+
+
+typedef  unsigned char   UChar;
+typedef    signed char   Char;
+typedef           char   HChar; /* signfulness depends on host */
+
+typedef  unsigned int    UInt;
+typedef    signed int    Int;
+
+typedef  unsigned char   Bool;
+#define  True   ((Bool)1)
+#define  False  ((Bool)0)
+
+typedef  unsigned long   UWord;
+
+typedef  UWord           SizeT;
+typedef  UWord           Addr;
+
+typedef  unsigned long long int   ULong;
+typedef    signed long long int   Long;
+
+
+
+__attribute__((noreturn))
+void fail ( HChar* msg )
+{
+   fprintf(stderr, "fixup_macho_loadcmds: fail: %s\n", msg);
+   exit(1);
+}
+
+
+/*------------------------------------------------------------*/
+/*---                                                      ---*/
+/*--- Mach-O file mapping/unmapping helpers                ---*/
+/*---                                                      ---*/
+/*------------------------------------------------------------*/
+
+typedef
+   struct {
+      /* These two describe the entire mapped-in ("primary") image,
+         fat headers, kitchen sink, whatnot: the entire file.  The
+         image is mapped into img[0 .. img_szB-1]. */
+      UChar* img;
+      SizeT  img_szB;
+      /* These two describe the Mach-O object of interest, which is
+         presumably somewhere inside the primary image.
+         map_image_aboard() below, which generates this info, will
+         carefully check that the macho_ fields denote a section of
+         memory that falls entirely inside img[0 .. img_szB-1]. */
+      UChar* macho_img;
+      SizeT  macho_img_szB;
+   }
+   ImageInfo;
+
+
+Bool is_macho_object_file( const void* buf, SizeT szB )
+{
+   /* (JRS: the Mach-O headers might not be in this mapped data,
+      because we only mapped a page for this initial check,
+      or at least not very much, and what's at the start of the file
+      is in general a so-called fat header.  The Mach-O object we're
+      interested in could be arbitrarily far along the image, and so
+      we can't assume its header will fall within this page.) */
+
+   /* But we can say that either it's a fat object, in which case it
+      begins with a fat header, or it's unadorned Mach-O, in which
+      case it starts with a normal header.  At least do what checks we
+      can to establish whether or not we're looking at something
+      sane. */
+
+   const struct fat_header*  fh_be = buf;
+   const struct mach_header_64* mh    = buf;
+
+   assert(buf);
+   if (szB < sizeof(struct fat_header))
+      return False;
+   if (ntohl(fh_be->magic) == FAT_MAGIC)
+      return True;
+
+   if (szB < sizeof(struct mach_header_64))
+      return False;
+   if (mh->magic == MH_MAGIC_64)
+      return True;
+
+   return False;
+}
+
+
+/* Unmap an image mapped in by map_image_aboard. */
+static void unmap_image ( /*MOD*/ImageInfo* ii )
+{
+   Int r;
+   assert(ii->img);
+   assert(ii->img_szB > 0);
+   r = munmap( ii->img, ii->img_szB );
+   /* Do we care if this fails?  I suppose so; it would indicate
+      some fairly serious snafu with the mapping of the file. */
+   assert( !r );
+   memset(ii, 0, sizeof(*ii));
+}
+
+
+/* Map a given fat or thin object aboard, find the thin part if
+   necessary, do some checks, and write details of both the fat and
+   thin parts into *ii.  Returns 32 (and leaves the file unmapped) if
+   the thin part is a 32 bit file.  Returns 64 if it's a 64 bit file.
+   Does not return on failure.  Guarantees to return pointers to a
+   valid(ish) Mach-O image if it succeeds. */
+static Int map_image_aboard ( /*OUT*/ImageInfo* ii, HChar* filename )
+{
+   memset(ii, 0, sizeof(*ii));
+
+   /* First off, try to map the thing in. */
+   { SizeT  size;
+     Int r, fd;
+     struct stat stat_buf;
+
+     r = stat(filename, &stat_buf);
+     if (r)
+        fail("Can't stat image (to determine its size)?!");
+     size = stat_buf.st_size;
+
+     fd = open(filename, O_RDWR, 0);
+     if (fd == -1)
+        fail("Can't open image for possible modification!");
+     if (DEBUGPRINTING)
+        printf("size %lu fd %d\n", size, fd);
+     void* v = mmap ( NULL, size, PROT_READ|PROT_WRITE,
+                                  MAP_FILE|MAP_SHARED, fd, 0 );
+     if (v == MAP_FAILED) {
+        perror("mmap failed");
+        fail("Can't mmap image for possible modification!");
+     }
+
+     close(fd);
+
+     ii->img     = (UChar*)v;
+     ii->img_szB = size;
+   }
+
+   /* Now it's mapped in and we have .img and .img_szB set.  Look for
+      the embedded Mach-O object.  If not findable, unmap and fail. */
+   { struct fat_header*  fh_be;
+     struct fat_header   fh;
+     struct mach_header_64* mh;
+
+     // Assume initially that we have a thin image, and update
+     // these if it turns out to be fat.
+     ii->macho_img     = ii->img;
+     ii->macho_img_szB = ii->img_szB;
+
+     // Check for fat header.
+     if (ii->img_szB < sizeof(struct fat_header))
+        fail("Invalid Mach-O file (0 too small).");
+
+     // Fat header is always BIG-ENDIAN
+     fh_be = (struct fat_header *)ii->img;
+     fh.magic = ntohl(fh_be->magic);
+     fh.nfat_arch = ntohl(fh_be->nfat_arch);
+     if (fh.magic == FAT_MAGIC) {
+        // Look for a good architecture.
+        struct fat_arch *arch_be;
+        struct fat_arch arch;
+        Int f;
+        if (ii->img_szB < sizeof(struct fat_header)
+                          + fh.nfat_arch * sizeof(struct fat_arch))
+           fail("Invalid Mach-O file (1 too small).");
+
+        for (f = 0, arch_be = (struct fat_arch *)(fh_be+1);
+             f < fh.nfat_arch;
+             f++, arch_be++) {
+           Int cputype;
+#          if defined(PLAT_x86_darwin)
+           cputype = CPU_TYPE_X86;
+#          elif defined(PLAT_amd64_darwin)
+           cputype = CPU_TYPE_X86_64;
+#          else
+#            error "unknown architecture"
+#          endif
+           arch.cputype    = ntohl(arch_be->cputype);
+           arch.cpusubtype = ntohl(arch_be->cpusubtype);
+           arch.offset     = ntohl(arch_be->offset);
+           arch.size       = ntohl(arch_be->size);
+           if (arch.cputype == cputype) {
+              if (ii->img_szB < arch.offset + arch.size)
+                 fail("Invalid Mach-O file (2 too small).");
+              ii->macho_img     = ii->img + arch.offset;
+              ii->macho_img_szB = arch.size;
+              break;
+           }
+        }
+        if (f == fh.nfat_arch)
+           fail("No acceptable architecture found in fat file.");
+     }
+
+     /* Sanity check what we found. */
+
+     /* assured by logic above */
+     assert(ii->img_szB >= sizeof(struct fat_header));
+
+     if (ii->macho_img_szB < sizeof(struct mach_header_64))
+        fail("Invalid Mach-O file (3 too small).");
+
+     if (ii->macho_img_szB > ii->img_szB)
+        fail("Invalid Mach-O file (thin bigger than fat).");
+
+     if (ii->macho_img >= ii->img
+         && ii->macho_img + ii->macho_img_szB <= ii->img + ii->img_szB) {
+        /* thin entirely within fat, as expected */
+     } else {
+        fail("Invalid Mach-O file (thin not inside fat).");
+     }
+
+     mh = (struct mach_header_64 *)ii->macho_img;
+     if (mh->magic == MH_MAGIC) {
+        assert(ii->img);
+        assert(ii->macho_img);
+        assert(ii->img_szB > 0);
+        assert(ii->macho_img_szB > 0);
+        assert(ii->macho_img >= ii->img);
+        assert(ii->macho_img + ii->macho_img_szB <= ii->img + ii->img_szB);
+        return 32;
+     }
+     if (mh->magic != MH_MAGIC_64)
+        fail("Invalid Mach-O file (bad magic).");
+
+     if (ii->macho_img_szB < sizeof(struct mach_header_64) + mh->sizeofcmds)
+        fail("Invalid Mach-O file (4 too small).");
+   }
+
+   assert(ii->img);
+   assert(ii->macho_img);
+   assert(ii->img_szB > 0);
+   assert(ii->macho_img_szB > 0);
+   assert(ii->macho_img >= ii->img);
+   assert(ii->macho_img + ii->macho_img_szB <= ii->img + ii->img_szB);
+   return 64;
+}
+
+
+/*------------------------------------------------------------*/
+/*---                                                      ---*/
+/*--- Mach-O top-level processing                          ---*/
+/*---                                                      ---*/
+/*------------------------------------------------------------*/
+
+void modify_macho_loadcmds ( HChar* filename,
+                             ULong  expected_stack_start,
+                             ULong  expected_stack_size )
+{
+   ImageInfo ii;
+   memset(&ii, 0, sizeof(ii));
+
+   Int size = map_image_aboard( &ii, filename );
+   if (size == 32) {
+      fprintf(stderr, "fixup_macho_loadcmds:   Is 32-bit MachO file;"
+              " no modifications needed.\n");
+      goto out;
+   }
+
+   assert(size == 64);
+
+   assert(ii.macho_img != NULL && ii.macho_img_szB > 0);
+
+   /* Poke around in the Mach-O header, to find some important
+      stuff.
+      * the location of the __UNIXSTACK load command, if any
+      * the location of the __LINKEDIT load command, if any
+      * the initial RSP value as stated in the LC_UNIXTHREAD
+   */
+
+   /* The collected data */
+   ULong init_rsp = 0;
+   Bool  have_rsp = False;
+   struct segment_command_64* seg__unixstack = NULL;
+   struct segment_command_64* seg__linkedit  = NULL;
+
+   /* Loop over the load commands and fill in the above 4 variables. */
+
+   { struct mach_header_64 *mh = (struct mach_header_64 *)ii.macho_img;
+      struct load_command *cmd;
+      Int c;
+
+      for (c = 0, cmd = (struct load_command *)(mh+1);
+           c < mh->ncmds;
+           c++, cmd = (struct load_command *)(cmd->cmdsize
+                                              + (unsigned long)cmd)) {
+         if (DEBUGPRINTING)
+            printf("load cmd: offset %4lu   size %3d   kind %2d = ",
+                   (unsigned long)((UChar*)cmd - (UChar*)ii.macho_img),
+                   cmd->cmdsize, cmd->cmd);
+
+         switch (cmd->cmd) {
+            case LC_SEGMENT_64:
+               if (DEBUGPRINTING)
+                  printf("LC_SEGMENT_64");
+               break;
+            case LC_SYMTAB:
+               if (DEBUGPRINTING)
+                  printf("LC_SYMTAB");
+               break;
+            case LC_UUID:
+               if (DEBUGPRINTING)
+                  printf("LC_UUID");
+               break;
+            case LC_UNIXTHREAD:
+               if (DEBUGPRINTING)
+                  printf("LC_UNIXTHREAD");
+               break;
+            default:
+                  printf("???");
+               fail("unexpected load command in Mach header");
+            break;
+         }
+         if (DEBUGPRINTING)
+            printf("\n");
+
+         /* Note what the stated initial RSP value is, so we can
+            check it is as expected. */
+         if (cmd->cmd == LC_UNIXTHREAD) {
+            struct thread_command* tcmd = (struct thread_command*)cmd;
+            UInt* w32s = (UInt*)( (UChar*)tcmd + sizeof(*tcmd) );
+            if (DEBUGPRINTING)
+               printf("UnixThread: flavor %u = ", w32s[0]);
+            if (w32s[0] == x86_THREAD_STATE64 && !have_rsp) {
+               if (DEBUGPRINTING)
+                  printf("x86_THREAD_STATE64\n");
+               x86_thread_state64_t* state64
+                  = (x86_thread_state64_t*)(&w32s[2]);
+               have_rsp = True;
+               init_rsp = state64->__rsp;
+               if (DEBUGPRINTING)
+                  printf("rsp = 0x%llx\n", init_rsp);
+            } else {
+               if (DEBUGPRINTING)
+                  printf("???");
+            }
+            if (DEBUGPRINTING)
+               printf("\n");
+         }
+
+         if (cmd->cmd == LC_SEGMENT_64) {
+            struct segment_command_64 *seg = (struct segment_command_64 *)cmd;
+            if (0 == strcmp(seg->segname, "__LINKEDIT"))
+               seg__linkedit = seg;
+            if (0 == strcmp(seg->segname, "__UNIXSTACK"))
+               seg__unixstack = seg;
+         }
+
+      }
+   }
+
+   /*
+      Actions are then as follows:
+
+      * (always) check the RSP value is as expected, and abort if not
+
+      * if there's a UNIXSTACK load command, check it is as expected.
+        If not abort, if yes, do nothing more.
+
+      * (so there's no UNIXSTACK load command).  if there's a LINKEDIT
+        load command, check if it is minimally usable (has 0 for
+        nsects and flags).  If yes, convert it to a UNIXSTACK load
+        command.  If there is none, or is unusable, then we're out of
+        options and have to abort.
+   */
+   if (!have_rsp)
+      fail("Can't find / check initial RSP setting");
+   if (init_rsp != expected_stack_start + expected_stack_size)
+      fail("Initial RSP value not as expected");
+
+   fprintf(stderr, "fixup_macho_loadcmds:   "
+                   "initial RSP is as expected (0x%llx)\n",
+                   expected_stack_start + expected_stack_size );
+
+   if (seg__unixstack) {
+      struct segment_command_64 *seg = seg__unixstack;
+      if (seg->vmaddr != expected_stack_start)
+         fail("has __UNIXSTACK, but wrong ::vmaddr");
+      if (seg->vmsize != expected_stack_size)
+         fail("has __UNIXSTACK, but wrong ::vmsize");
+      if (seg->maxprot != 7)
+         fail("has __UNIXSTACK, but wrong ::maxprot (should be 7)");
+      if (seg->initprot != 3)
+         fail("has __UNIXSTACK, but wrong ::initprot (should be 3)");
+      if (seg->nsects != 0)
+         fail("has __UNIXSTACK, but wrong ::nsects (should be 0)");
+      if (seg->flags != 0)
+         fail("has __UNIXSTACK, but wrong ::flags (should be 0)");
+      /* looks ok */
+      fprintf(stderr, "fixup_macho_loadcmds:   "
+              "acceptable __UNIXSTACK present; no modifications.\n" );
+      goto out;
+   }
+
+   if (seg__linkedit) {
+      struct segment_command_64 *seg = seg__linkedit;
+      if (seg->nsects != 0)
+         fail("has __LINKEDIT, but wrong ::nsects (should be 0)");
+      if (seg->flags != 0)
+         fail("has __LINKEDIT, but wrong ::flags (should be 0)");
+      fprintf(stderr, "fixup_macho_loadcmds:   "
+              "no __UNIXSTACK present.\n" );
+      fprintf(stderr, "fixup_macho_loadcmds:   "
+              "converting __LINKEDIT to __UNIXSTACK.\n" );
+      strcpy(seg->segname, "__UNIXSTACK");
+      seg->vmaddr   = expected_stack_start;
+      seg->vmsize   = expected_stack_size;
+      seg->fileoff  = 0;
+      seg->filesize = 0;
+      seg->maxprot  = 7;
+      seg->initprot = 3;
+      /* success */
+      goto out;
+   }
+
+   /* out of options */
+   fail("no __UNIXSTACK found and no usable __LINKEDIT found; "
+        "out of options.");
+   /* NOTREACHED */
+
+  out:
+   if (ii.img)
+      unmap_image(&ii);
+}
+
+
+static Bool is_plausible_tool_exe_name ( HChar* nm )
+{
+   HChar* p;
+   if (!nm)
+      return False;
+
+   // Does it end with this string?
+   p = strstr(nm, "-x86-darwin");
+   if (p && 0 == strcmp(p, "-x86-darwin"))
+      return True;
+
+   p = strstr(nm, "-amd64-darwin");
+   if (p && 0 == strcmp(p, "-amd64-darwin"))
+      return True;
+
+   return False;
+}
+
+
+int main ( int argc, char** argv )
+{
+   Int   r;
+   ULong req_stack_addr = 0;
+   ULong req_stack_size = 0;
+
+   if (argc != 4)
+      fail("args: -stack_addr-arg -stack_size-arg "
+           "name-of-tool-executable-to-modify");
+
+   r= sscanf(argv[1], "0x%llx", &req_stack_addr);
+   if (r != 1) fail("invalid stack_addr arg");
+
+   r= sscanf(argv[2], "0x%llx", &req_stack_size);
+   if (r != 1) fail("invalid stack_size arg");
+
+   fprintf(stderr, "fixup_macho_loadcmds: "
+           "requested stack_addr (top) 0x%llx, "
+           "stack_size 0x%llx\n", req_stack_addr, req_stack_size );
+
+   if (!is_plausible_tool_exe_name(argv[3]))
+      fail("implausible tool exe name -- not of the form *-{x86,amd64}-darwin");
+
+   fprintf(stderr, "fixup_macho_loadcmds: examining tool exe: %s\n",
+           argv[3] );
+   modify_macho_loadcmds( argv[3], req_stack_addr - req_stack_size,
+                          req_stack_size );
+
+   return 0;
+}
+
+/*
+      cmd LC_SEGMENT_64
+  cmdsize 72
+  segname __LINKEDIT
+   vmaddr 0x0000000138dea000
+   vmsize 0x00000000000ad000
+  fileoff 2658304
+ filesize 705632
+  maxprot 0x00000007
+ initprot 0x00000001
+   nsects 0
+    flags 0x0
+*/
+
+/*
+      cmd LC_SEGMENT_64
+  cmdsize 72
+  segname __UNIXSTACK
+   vmaddr 0x0000000133800000
+   vmsize 0x0000000000800000
+  fileoff 2498560
+ filesize 0
+  maxprot 0x00000007
+ initprot 0x00000003
+   nsects 0
+    flags 0x0
+*/
Index: coregrind/link_tool_exe_darwin.in
===================================================================
--- coregrind/link_tool_exe_darwin.in	(revision 11685)
+++ coregrind/link_tool_exe_darwin.in	(working copy)
@@ -160,14 +160,31 @@
     }
 }

-#print "link_tool_exe_darwin: $cmd\n";
+print "link_tool_exe_darwin: $cmd\n";

-
 # Execute the command:
 my $r = system("$cmd");

-if ($r == 0) {
-    exit 0;
-} else {
-    exit 1;
+if ($r != 0) {
+   exit 1;
 }
+
+
+# and now kludge the tool exe
+# see bug 267997
+
+$cmd = "../coregrind/fixup_macho_loadcmds";
+$cmd = "$cmd $stack_addr_str $stack_size_str $outname";
+
+print "link_tool_exe_darwin: $cmd\n";
+
+my $r = system("$cmd");
+
+if ($r != 0) {
+   exit 1;
+}
+
+
+
+
+exit 0;
Index: coregrind/Makefile.am
===================================================================
--- coregrind/Makefile.am	(revision 11685)
+++ coregrind/Makefile.am	(working copy)
@@ -441,3 +441,18 @@

 install-exec-local: install-noinst_PROGRAMS install-noinst_DSYMS

+#----------------------------------------------------------------------------
+# Darwin linker kludges
+#----------------------------------------------------------------------------
+
+if VGCONF_OS_IS_DARWIN
+
+BUILT_SOURCES += fixup_macho_loadcmds
+fixup_macho_loadcmds: fixup_macho_loadcmds.c
+	$(CC) -g -Wall -o fixup_macho_loadcmds fixup_macho_loadcmds.c
+
+CLEANFILES += fixup_macho_loadcmds
+
+endif
+
+EXTRA_DIST += fixup_macho_loadcmds.c
