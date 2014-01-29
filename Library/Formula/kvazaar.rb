require "formula"

class Kvazaar < Formula
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.2.0.tar.gz"
  sha1 "b0f23dc0d421e64183deba8fdcd2347863d711d5"

  depends_on 'yasm' => :build

  def install
    cd 'src' do
      system 'make'
      bin.install 'kvazaar'
    end
  end

  def patches
    DATA
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index ab56e9d..bf005c7 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -35,10 +35,10 @@ $(PROG): $(OBJS) $(ASMOBJS)
 	$(LD) $(LDFLAGS) $^ -o $@
 
 test.o: x86/test.asm
-	$(YASM) -f elf x86/test.asm -o test.o
+	$(YASM) -f macho32 x86/test.asm -o test.o
 
 test64.o: x64/test64.asm
-	$(YASM) -f elf64 x64/test64.asm -o test64.o
+	$(YASM) -f macho64 x64/test64.asm -o test64.o
 
 %.o: %.c
 	$(CC) $(CCFLAGS) -c $< -o $@
diff --git a/src/x64/test64.asm b/src/x64/test64.asm
index b112767..17ef077 100644
--- a/src/x64/test64.asm
+++ b/src/x64/test64.asm
@@ -1,11 +1,11 @@
 ; Function to get CPUID for identifying CPU capabilities
 bits 64
 section .code
-global cpuId64
+global _cpuId64
 
 ;void __cdecl cpuId64(int* ecx, int *edx );
 
-cpuId64:
+_cpuId64:
     push rbx
     mov  r8, rcx ; pointer to ecx-output
     mov  r9, rdx ; pointer to edx-output

