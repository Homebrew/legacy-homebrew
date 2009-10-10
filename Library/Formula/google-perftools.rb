require 'brewkit'

class GooglePerftools <Formula
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.4.tar.gz'
  homepage 'http://code.google.com/p/google-perftools/'
  md5 'e9383c158dcb3f4a789564498ec3f046'

  def patches
    if Hardware.is_64_bit? and MACOS_VERSION == 10.6
      {"p0" => DATA}
    end
  end


  def install
    system "CFLAGS='-D_XOPEN_SOURCE' CXXFLAGS='-D_XOPEN_SOURCE' ./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

__END__
Index: src/pprof
===================================================================
--- src/pprof	(revision 76)
+++ src/pprof	(working copy)
@@ -3181,7 +3181,7 @@
       $sectname = $1;
     } elsif ($line =~ /segname (\w+)/) {
       $segname = $1;
-    } elsif (!($cmd eq "LC_SEGMENT" &&
+    } elsif (!(($cmd eq "LC_SEGMENT" || $cmd eq "LC_SEGMENT_64") &&
 	       $sectname eq "__text" &&
 	       $segname eq "__TEXT")) {
       next;
Index: src/base/sysinfo.cc
===================================================================
--- src/base/sysinfo.cc	(revision 76)
+++ src/base/sysinfo.cc	(working copy)
@@ -728,26 +728,59 @@
 
     // We start with the next load command (we've already looked at this one).
     for (current_load_cmd_--; current_load_cmd_ >= 0; current_load_cmd_--) {
-      const char* lc = ((const char *)hdr + sizeof(struct mach_header));
+      const char* lc;
+      uint32_t seg_marker;
+      #if defined(MH_MAGIC_64)
+      if (hdr->magic == MH_MAGIC_64) {
+        lc = ((const char *)hdr + sizeof(struct mach_header_64));
+        seg_marker = LC_SEGMENT_64;
+      } else {
+      #endif
+        lc  = ((const char *)hdr + sizeof(struct mach_header));
+        seg_marker = LC_SEGMENT;
+      #if defined(MH_MAGIC_64)
+      }
+      #endif
       // TODO(csilvers): make this not-quadradic (increment and hold state)
       for (int j = 0; j < current_load_cmd_; j++)  // advance to *our* load_cmd
         lc += ((const load_command *)lc)->cmdsize;
-      if (((const load_command *)lc)->cmd == LC_SEGMENT) {
+      if (((const load_command *)lc)->cmd == seg_marker) {
         const intptr_t dlloff = _dyld_get_image_vmaddr_slide(current_image_);
-        const segment_command* sc = (const segment_command *)lc;
-        if (start) *start = sc->vmaddr + dlloff;
-        if (end) *end = sc->vmaddr + sc->vmsize + dlloff;
-        if (flags) *flags = kDefaultPerms;  // can we do better?
-        if (offset) *offset = sc->fileoff;
-        if (inode) *inode = 0;
-        if (filename)
-          *filename = const_cast<char*>(_dyld_get_image_name(current_image_));
-        if (file_mapping) *file_mapping = 0;
-        if (file_pages) *file_pages = 0;   // could we use sc->filesize?
-        if (anon_mapping) *anon_mapping = 0;
-        if (anon_pages) *anon_pages = 0;
-        if (dev) *dev = 0;
-        return true;
+        #if defined(MH_MAGIC_64)
+        if (hdr->magic == MH_MAGIC_64) {
+          const segment_command_64* sc = (const segment_command_64 *)lc;
+          if (start) *start = sc->vmaddr + dlloff;
+          if (end) *end = sc->vmaddr + sc->vmsize + dlloff;
+          if (flags) *flags = kDefaultPerms;  // can we do better?
+          if (offset) *offset = sc->fileoff;
+          if (inode) *inode = 0;
+          if (filename)
+            *filename = const_cast<char*>(_dyld_get_image_name(current_image_));
+          if (file_mapping) *file_mapping = 0;
+          if (file_pages) *file_pages = 0;   // could we use sc->filesize?
+          if (anon_mapping) *anon_mapping = 0;
+          if (anon_pages) *anon_pages = 0;
+          if (dev) *dev = 0;
+          return true;
+        } else {
+        #endif
+          const segment_command* sc = (const segment_command *)lc;
+          if (start) *start = sc->vmaddr + dlloff;
+          if (end) *end = sc->vmaddr + sc->vmsize + dlloff;
+          if (flags) *flags = kDefaultPerms;  // can we do better?
+          if (offset) *offset = sc->fileoff;
+          if (inode) *inode = 0;
+          if (filename)
+            *filename = const_cast<char*>(_dyld_get_image_name(current_image_));
+          if (file_mapping) *file_mapping = 0;
+          if (file_pages) *file_pages = 0;   // could we use sc->filesize?
+          if (anon_mapping) *anon_mapping = 0;
+          if (anon_pages) *anon_pages = 0;
+          if (dev) *dev = 0;
+          return true;
+        #if defined(MH_MAGIC_64)
+        }
+        #endif
       }
     }
     // If we get here, no more load_cmd's in this image talk about