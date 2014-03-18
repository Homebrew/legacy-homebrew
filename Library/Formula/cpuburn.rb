require "formula"

class Cpuburn < Formula
  homepage "http://packages.debian.org/stable/misc/cpuburn"
  url "http://ftp.de.debian.org/debian/pool/main/c/cpuburn/cpuburn_1.4a.orig.tar.gz"
  sha256 "eb191ce9bfbf453d30c218c3419573df102a3588f96c4a43686c84bb9da4bed6"

  patch do
    url "http://patch-tracker.debian.org/patch/series/dl/cpuburn/1.4a-3/01-variables.patch"
    sha1 "261dcf6d11aff9c2c315acf163b17f9fb3c8937d"
  end

  patch do
    url "http://patch-tracker.debian.org/patch/series/dl/cpuburn/1.4a-3/02-m32.patch"
    sha1 "bc3551597bab597fc6149a66413c76ad9a7208d5"
  end

  patch :DATA

  def install
    ENV.m32

    system "make"

    bin.install "burnP5", "burnP6", "burnK6", "burnK7", "burnBX", "burnMMX"
    doc.install "README"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 429b1d8..f5c90db 100644
--- a/Makefile
+++ b/Makefile
@@ -1,3 +1,3 @@
 all : burnP5 burnP6 burnK6 burnK7 burnBX burnMMX
 .S:
-	gcc -m32 -s -nostdlib -o $@ $<
+	gcc -m32 -s -nostdlib -static -e _start -o $@ $<
diff --git a/burnBX.S b/burnBX.S
index 198b16c..b92aac6 100644
--- a/burnBX.S
+++ b/burnBX.S
@@ -94,7 +94,7 @@ mov_again:
 
 	movl	$buffer, %edi	# DATA CHECK
 	xorl	%ecx, %ecx
-.align 16, 0x90
+.balign 16, 0x90
 test:
 	mov	0(%edi,%ecx,4), %eax
 	cmp	%eax, 4(%edi,%ecx,4)
@@ -117,7 +117,7 @@ error:				# error abend
 	int	$0x80
 #endif
 .bss				# Data allocation
-.align 32
+.balign 32
 .lcomm	buffer,	 32 <<20	# reduce both to 8 <<20 for only
 .lcomm	buf2,	 32 <<20	# 16 MB virtual memory available
 
diff --git a/burnK6.S b/burnK6.S
index a7425bf..fea7abb 100644
--- a/burnK6.S
+++ b/burnK6.S
@@ -29,7 +29,7 @@ after_check:
 	lea	-1(%eax), %esi
 	movl	$400000000, %ecx  
 	movl	%ecx, -4(%ebp)	 
-.align	32,  0x90
+.balign	32,  0x90
 crunch:				
 	fldl	8-24(%ebp,%esi,8)	# CALC BLOCK
 	fmull	8-32(%ebp,%esi,8)
@@ -69,7 +69,7 @@ int_exit:
 	int	$0x80
 #endif
 .data				# Data allocation
-.align 32,0
+.balign 32,0
 half:	.long 0x7fffffff,0
 e:	.long 0xffffffff,0x3fdfffff
 rt:	.long 0xffffffff,0x3fefffff
diff --git a/burnK7.S b/burnK7.S
index 9d41871..4c151c1 100644
--- a/burnK7.S
+++ b/burnK7.S
@@ -31,7 +31,7 @@ _start:
 	movl	%edx, -8(%ebp)
 after_check:
 	movl	$850000000, -4(%ebp)  
-.align	32,  0x90
+.balign	32,  0x90
 crunch:				
 	fxch				# CALC BLOCK
 	fldl	8-24(%ebp,%esi,8)	# 17 instr / 6.0 cycles
@@ -75,8 +75,8 @@ int_exit:
 	int	$0x80
 #endif
 .data				# Data allocation
-.align 32,0
-	.fill 64
+.balign 32,0
+	.fill 64,1,0
 half:	.long 0x7fffffff,0
 e:	.long 0xffffffff,0x3fdfffff
 rt:	.long 0xffffffff,0x3fefffff
diff --git a/burnMMX.S b/burnMMX.S
index 6a0841f..32a9d69 100644
--- a/burnMMX.S
+++ b/burnMMX.S
@@ -81,7 +81,7 @@ mov_again:
 	addl	%ecx, %esi
 	addl	%ecx, %edi
 	negl	%ecx
-.align 16, 0x90
+.balign 16, 0x90
 0:				    # WORKLOOP 7 uops/ 3 clks in L1
 	movq	0(%esi,%ecx),%mm7
 	pmaddwd %mm0, %mm1
@@ -98,7 +98,7 @@ mov_again:
 	addl	%ecx, %esi
 	addl	%ecx, %edi
 	negl	%ecx
-.align 16, 0x90
+.balign 16, 0x90
 0:				   # second workloop
 	movq	0(%esi,%ecx),%mm7
 	pmaddwd %mm0, %mm1
@@ -154,7 +154,7 @@ error:				# error abend
 rt:	.long	0x7fffffff, 0x7fffffff
 
 .bss				# Data allocation
-.align 32
+.balign 32
 .lcomm	buffer,	 32 <<20	# reduce both to 8 <<20 for only
 .lcomm	buf2,	 32 <<20	# 16 MB virtual memory available
 
diff --git a/burnP5.S b/burnP5.S
index c55dbc8..97a139a 100644
--- a/burnP5.S
+++ b/burnP5.S
@@ -26,7 +26,7 @@ after_check:
 	xorl	%eax, %eax
 	movl	%eax, %ebx
 	movl	$200000000, %ecx
-.align	32,  0x90
+.balign	32,  0x90
 				# MAIN LOOP  16 flops / 18 cycles
 crunch:	   
 	fmull	-24(%ebp)
@@ -78,7 +78,7 @@ crunch:
 	int	$0x80
 #endif
 .data				# Data allocation
-.align 32,0
+.balign 32,0
 half:	.long 0xffffffff,0x3fdfffff
 one:	.long 0xffffffff,0x3fefffff
 
diff --git a/burnP6.S b/burnP6.S
index 017c481..2366ec5 100644
--- a/burnP6.S
+++ b/burnP6.S
@@ -29,7 +29,7 @@ after_check:
 	lea	-1(%eax), %esi
 	movl	$539000000, %ecx    # check after this count  
 	movl	%ecx, -4(%ebp)	   
-.align	32,  0x90
+.balign	32,  0x90
 crunch:				   # MAIN LOOP	21uops / 8.0 clocks
 	fldl	8-24(%ebp,%esi,8)  
 	fmull	8-32(%ebp,%esi,8)
@@ -70,7 +70,7 @@ int_exit:			# error abort
 	int	$0x80
 #endif
 .data				# Data allocation
-.align 32,0
+.balign 32,0
 half:	.long 0x7fffffff,0
 e:	.long 0xffffffff,0x3fdfffff
 rt:	.long 0xffffffff,0x3fefffff
