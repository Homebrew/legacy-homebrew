require 'formula'

class Visualboyadvance <Formula
  url "http://downloads.sourceforge.net/project/vba/VisualBoyAdvance/1.7.2/VisualBoyAdvance-src-1.7.2.tar.gz"
  homepage 'http://vba.ngemu.com/' # This homepage is sketchy
  md5 'cc02339e3fd8efd9f23121b0a2f81fd8'

  depends_on 'pkg-config'
  depends_on 'libpng'
  depends_on 'sdl'

  def patches
    DATA
  end

  def install
    fails_with_llvm "Video scalers don't link right w/ LLVM"
    ENV.x11 # for libpng

    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          # Use straight C, and don't get fancy
                          "--enable-c-core",
                          "--without-mmx",
                          # Use SDL and don't bother testing for it
                          "--enable-sdl",
                          "--disable-sdltest"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/src/System.h b/src/System.h
index 2cc6d49..74d12cc 100644
--- a/src/System.h
+++ b/src/System.h
@@ -46,6 +46,12 @@ typedef signed __int64 s64;
 typedef signed long long s64;
 #endif
 
+#ifdef __APPLE__
+typedef u64 memptr;
+#else
+typedef u32 memptr;
+#endif
+
 struct EmulatedSystem {
   // main emulation function
   void (*emuMain)(int);
diff --git a/src/prof/prof.cpp b/src/prof/prof.cpp
index 3ef7894..bd3c982 100644
--- a/src/prof/prof.cpp
+++ b/src/prof/prof.cpp
@@ -80,6 +80,18 @@ static char hist_dimension_abbrev = 's';
 /* see profil(2) where this is describe (incorrectly) */
 #define  SCALE_1_TO_1 0x10000L
 
+void profPut64(char *b, u64 v)
+{
+  b[0] = v & 255;
+  b[1] = (v >> 8) & 255;
+  b[2] = (v >> 16) & 255;
+  b[3] = (v >> 24) & 255;
+  b[4] = (v >> 32) & 255;
+  b[5] = (v >> 40) & 255;
+  b[6] = (v >> 48) & 255;
+  b[7] = (v >> 56) & 255;
+}
+
 void profPut32(char *b, u32 v)
 {
   b[0] = v & 255;
@@ -111,6 +123,21 @@ int profWrite32(FILE *f, u32 v)
   return 0;
 }
 
+#ifdef __APPLE__
+int profWrite64(FILE *f, u64 v)
+{
+  char buf[8];
+
+  profPut64(buf, v);
+  if(fwrite(buf, 1, 8, f) != 8)
+    return 1;
+  return 0;
+}
+#define profWriteMemptr profWrite64
+#else
+#define profWriteMemptr profWrite32
+#endif
+
 int profWrite(FILE *f, char *buf, unsigned int n)
 {
   if(fwrite(buf, 1, n, f) != n)
@@ -266,7 +293,7 @@ void profCleanup()
     for (toindex=froms[fromindex]; toindex!=0; toindex=tos[toindex].link) {
       if(profWrite8(fd, GMON_TAG_CG_ARC) ||
          profWrite32(fd, (u32)frompc) ||
-         profWrite32(fd, (u32)tos[toindex].selfpc) ||
+         profWriteMemptr(fd, (memptr)tos[toindex].selfpc) ||
          profWrite32(fd, tos[toindex].count)) {
         systemMessage(0, "mcount: arc");
         fclose(fd);
diff --git a/src/sdl/debugger.cpp b/src/sdl/debugger.cpp
index 1657a9e..4d89d99 100644
--- a/src/sdl/debugger.cpp
+++ b/src/sdl/debugger.cpp
@@ -946,13 +946,13 @@ void debuggerBreakArm(int n, char **args)
     debuggerUsage("ba");
 }
 
-void debuggerBreakOnWrite(u32 *mem, u32 oldvalue, u32 value, int size)
+void debuggerBreakOnWrite(memptr *mem, u32 oldvalue, u32 value, int size)
 {
-  u32 address = 0;
-  if(mem >= (u32*)&workRAM[0] && mem <= (u32*)&workRAM[0x3ffff])
-    address = 0x2000000 + ((u32)mem - (u32)&workRAM[0]);
+  memptr address = 0;
+  if(mem >= (memptr*)&workRAM[0] && mem <= (memptr*)&workRAM[0x3ffff])
+    address = 0x2000000 + ((memptr)mem - (memptr)&workRAM[0]);
   else
-    address = 0x3000000 + ((u32)mem - (u32)&internalRAM[0]);
+    address = 0x3000000 + ((memptr)mem - (memptr)&internalRAM[0]);
 
   if(size == 2)
     printf("Breakpoint (on write) address %08x old:%08x new:%08x\n", 
