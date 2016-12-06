require 'formula'

class G77 < Formula

  homepage 'http://gcc.gnu.org/onlinedocs/gcc-3.4.3/g77/index.html'
  url "http://ftp.gnu.org/gnu/gcc/gcc-3.4.3/gcc-3.4.3.tar.bz2"
  sha1 'f20c691662831e8022c7f9588cbd6aeb9c40fd2a'

  @@release = 1 # Homebrew package release number

  # option "without-openmp", "Disable OpenMP support"
  # option "without-m64", "Disable 64-bit binaries"

  def patches
    # Adds i386 and ppc support for insn patterns encountered in code
    # involving variables in COMMON storage.
    system 'pwd; ls'
    { :p2 => DATA }
  end

  def install
    ENV.deparallelize

    system "cd gcc; autoconf"
    system "cd gcc; autoheader"
    inreplace "gcc/version.c",
       "#{version}", "#{version} (HB-%d)" % @@release
    inreplace "gcc/Makefile.in", 
       '$(ALL_CPPFLAGS) $(INCLUDES)', '$(INCLUDES) $(ALL_CPPFLAGS)'
    majrel=`/usr/bin/uname -r | awk -F. '{print $1}'`.strip
    if File.exist? "/usr/lib/libSystemStubs.a"
       inreplace "gcc/config/darwin.h", 
          '-lSystem',
          "%{!mlong-double-64:%{pg:-lSystemStubs_profile;:-lSystemStubs}} -lSystem -lmx %:if-exists(/usr/lib/gcc/i686-apple-darwin#{majrel}/4.0.1/libgcc.a)"
    end
    system "cd gcc; egrep -rI '(head|tail) +\-[0-9]' *|cut -f1 -d:|sort -u|xargs perl -pi -e 's,(head|tail) +\-([0-9]),\1 \-n\2,g'"

    # Configure phase -m32 needed because 3.4.3 is 32 bit only compiler, and
    #  _FORTIFY_SOURCE=0 needed to suppress Apple /usr/include/*.h references to
    #  undefined compiler __builtin__ functions.
    mkdir '../darwin'
    chdir '../darwin'
    system "../gcc-#{version}/configure",
      "--enable-languages=f77",
      "--infodir='#{info}'",
      "--libexecdir='#{libexec}'",
      "--disable-shared"
    system "make",
      "CFLAGS=-O -fno-common -m32 -D_FORTIFY_SOURCE=0",
      "LIBCFLAGS=-O2 -fno-common -m32 -D_FORTIFY_SOURCE=0",
      "LIBCXXFLAGS=-O2 -fno-implicit-templates",
      "STAGE1_CFLAGS=-m32 -D_FORTIFY_SOURCE=0",
      "BOOT_CFLAGS=-D_FORTIFY_SOURCE=0",
      "bootstrap"

    # Build phase
    system "make install prefix=#{prefix}"
    system "cd #{bin}; rm -f gcc gccbug cpp gcov powerpc-apple*"
    darwinvers=`/usr/bin/uname -v | cut -f1 -d":" | awk '{print $4}'`.strip
    gccvers=`#{bin}/g77 -dumpversion | awk 'NR==1{print $4}'`.strip
    system "ln -s #{lib}/gcc/i386-apple-darwin#{darwinvers}/#{gccvers}/include/g2c.h #{include}/g2c.h"
    system "rm -rf #{share}/locale #{man}"
    system "rm -rf #{lib}/charset.alias"
    system "rm -rf #{info}/gcc* #{info}/cpp*"
    system "mv -f #{lib}/libiberty.a #{lib}/libiberty-g77.a"
    system "for i in `find #{lib} -name '*.a'` ; do nmedit -p \$i ; done"

  end

  test do
    fixture = <<-EOS
         pi = 4*atan(1.0)
         print *,'Hello world!  pi is ',pi
         end
    EOS
    Pathname('test.f').write(fixture)
    system "#{bin}/g77 -c test.f"
    system "#{bin}/g77 -o test test.o"
    puts `./test`
    /Hello world!  pi is *[0-9.]*/ =~ `./test`.strip
  end
end

__END__
diff -ur gcc-3.4.3.orig/gcc/ChangeLog gcc-3.4.3/gcc/ChangeLog
--- ./gcc-3.4.3/gcc/ChangeLog	2004-11-05 03:33:38.000000000 +0000
+++ ./gcc-3.4.3/gcc/ChangeLog	2007-12-29 22:50:53.000000000 +0000
@@ -1,3 +1,58 @@
+2007-12-29  George Helffrich <ghfbsd@gly.bris.ac.uk>
+
+	* config/rs6000/host-darwin.c (sigaltstack): Protect prototype with
+	HAVE_DECL_SIGALTSTACK.
+	(MC_FLD): New.
+	(segv_handler): Use MC_FLD.
+	* configure.ac: Check for a sigaltstack declaration.
+	Compute HAS_MCONTEXT_T_UNDERSCORES on Darwin.
+	* configure: Regenerate.
+	* config.in: Regenerate.
+
+2007-10-07  George Helffrich <ghfbsd@gly.bris.ac.uk>
+
+        * config/i386/i386.c:  Recognize memory addressing expressions like
+	symbol-<pic base> as PIC constants.
+
+2006-12-25  George Helffrich <ghfbsd@gly.bris.ac.uk>
+
+        * config/i386/i386.c:  Parse addresses better in order to be able
+	to handle adds with base, index and displacement in any order
+	(addition is commutative, after all).  Allows for Fortran arrays
+	located in COMMON or SAVE areas to work properly.
+
+        * config/darwin.c:  Enable DWARF-2 debugging info, but leave STABS as
+	default.  Note:  DWARF-2 does not work with MacOS X 10.4 GDB, so using
+	this feature is pointless.
+        * config/darwin.h:  Ditto.
+
+2006-12-13  George Helffrich <ghfbsd@gly.bris.ac.uk>
+
+	* recog.c:  Fix problems with i386 insn recognition of SETs that
+	use array indices located in Fortran common to index an array also in
+	Fortran common.  insn not properly recognized because it caused
+	CLOBBERS of hard regs that weren't allowed for at recognition time.
+
+	* function.c:  Ditto.
+
+2006-09-30  George Helffrich <ghfbsd@gly.bris.ac.uk>
+
+        * config/i386/i386.c:  Handle i386 builds with new Xcode release with
+	NASM assembler.  jmp instruction syntax is more strict.
+
+2006-06-17  George Helffrich <ghfbsd@gly.bris.ac.uk>
+
+        * config/darwin-crt2.c:  Handle i386 builds; _init_keymgr not
+	defined in ABI and call not needed on i386 arch.
+
+2004-07-26  George Helffrich <ghfbsd@gly.bris.ac.uk>
+  
+        * dbxout.c: Change .stabs output for symbols in .comm (Fortran common)
+        to 1) bracket .stabs group of symbols with N_BCOMM/N_ECOMM; and
+        2) change N_LCSYM to N_GSYM for .comm symbols for compatibility with
+        Sun Fortran and "official" .stabs documentation.
+        * xcoffout.h: Add check for symbol scope in DBX_FINISH_SYMBOL.
+
 2004-11-04  Release Manager
 
 	* GCC 3.4.3 released.
diff -ur gcc-3.4.3.orig/gcc/config/darwin-crt2.c gcc-3.4.3/gcc/config/darwin-crt2.c
--- ./gcc-3.4.3.orig/gcc/config/darwin-crt2.c	2002-11-07 06:00:05.000000000 +0000
+++ ./gcc-3.4.3/gcc/config/darwin-crt2.c	2007-10-07 12:37:07.000000000 +0100
@@ -47,7 +47,12 @@
 extern void __darwin_gcc3_preregister_frame_info (void);
 
 /* These are from "keymgr.h".  */
+#if defined(__ppc__)
 extern void _init_keymgr (void);
+#endif
+#if defined(__i386__)
+#define _init_keymgr(a) /* NULL */
+#endif
 extern void *_keymgr_get_and_lock_processwide_ptr (unsigned key);
 extern void _keymgr_set_and_unlock_processwide_ptr (unsigned key, void *ptr);
 
diff -ur gcc-3.4.3.orig/gcc/config/darwin-protos.h gcc-3.4.3/gcc/config/darwin-protos.h
--- ./gcc-3.4.3.orig/gcc/config/darwin-protos.h	2004-09-11 21:32:16.000000000 +0100
+++ ./gcc-3.4.3/gcc/config/darwin-protos.h	2007-10-07 12:37:07.000000000 +0100
@@ -117,5 +117,6 @@
 extern void darwin_eh_frame_section (void);
 extern void darwin_globalize_label (FILE *, const char *);
 extern void darwin_assemble_visibility (tree, int);
+extern void darwin_asm_named_section (const char *, unsigned int);
 extern void darwin_asm_output_dwarf_delta (FILE *, int, const char *,
 					   const char *);
diff -ur gcc-3.4.3.orig/gcc/config/darwin.c gcc-3.4.3/gcc/config/darwin.c
--- ./gcc-3.4.3.orig/gcc/config/darwin.c	2004-09-11 21:32:16.000000000 +0100
+++ ./gcc-3.4.3/gcc/config/darwin.c	2007-10-07 12:37:07.000000000 +0100
@@ -1313,6 +1313,17 @@
 	     "in this configuration; ignored");
 }
 
+void
+darwin_asm_named_section (const char *name, unsigned int flags)
+{
+  const char *type = "";
+
+  if (flags & SECTION_DEBUG)
+    type = ", no_dead_strip";
+
+  fprintf (asm_out_file, "\t.section\t__TEXT, %s, regular%s\n", name, type);
+}
+
 /* Output a difference of two labels that will be an assembly time
    constant if the two labels are local.  (.long lab1-lab2 will be
    very different if lab1 is at the boundary between two sections; it
diff -ur gcc-3.4.3.orig/gcc/config/darwin.h gcc-3.4.3/gcc/config/darwin.h
--- ./gcc-3.4.3.orig/gcc/config/darwin.h	2004-09-11 21:32:17.000000000 +0100
+++ ./gcc-3.4.3/gcc/config/darwin.h	2007-10-07 12:37:07.000000000 +0100
@@ -300,6 +300,13 @@
 
 #define DBX_DEBUGGING_INFO 1
 
+/* We also use DWARF-2 symbol format.  */
+
+#define DWARF2_DEBUGGING_INFO 1
+
+#undef PREFERRED_DEBUGGING_TYPE
+#define PREFERRED_DEBUGGING_TYPE DBX_DEBUG
+
 /* When generating stabs debugging, use N_BINCL entries.  */
 
 #define DBX_USE_BINCL
@@ -338,6 +345,9 @@
 #undef	TARGET_ASM_FILE_START_FILE_DIRECTIVE
 #define TARGET_ASM_FILE_START_FILE_DIRECTIVE false
 
+#undef  TARGET_ASM_NAMED_SECTION
+#define TARGET_ASM_NAMED_SECTION darwin_asm_named_section
+
 #undef  TARGET_ASM_FILE_END
 #define TARGET_ASM_FILE_END darwin_file_end
 
diff -ur gcc-3.4.3.orig/gcc/config/i386/darwin.h gcc-3.4.3/gcc/config/i386/darwin.h
--- ./gcc-3.4.3.orig/gcc/config/i386/darwin.h	2004-08-23 19:02:49.000000000 +0100
+++ ./gcc-3.4.3/gcc/config/i386/darwin.h	2007-10-07 12:57:59.000000000 +0100
@@ -43,7 +43,7 @@
 
 /* Use the following macro for any Darwin/x86-specific command-line option
    translation.  */
-#define SUBTARGET_OPTION_TRANSLATE_TABLE
+#define SUBTARGET_OPTION_TRANSLATE_TABLE {0,0}
 
 #define ASM_SPEC "-arch i386 \
   %{Zforce_cpusubtype_ALL:-force_cpusubtype_ALL} \
diff -ur gcc-3.4.3.orig/gcc/dbxout.c gcc-3.4.3/gcc/dbxout.c
--- ./gcc-3.4.3.orig/gcc/dbxout.c	2004-08-04 08:32:19.000000000 +0100
+++ ./gcc-3.4.3/gcc/dbxout.c	2007-10-07 12:37:07.000000000 +0100
@@ -355,6 +355,8 @@
 static void dbxout_class_name_qualifiers (tree);
 static int dbxout_symbol_location (tree, tree, const char *, rtx);
 static void dbxout_symbol_name (tree, const char *, int);
+static void dbxout_common_name (tree, const char *, STAB_CODE_TYPE);
+static const char *dbxout_common_check (tree, int *);
 static void dbxout_prepare_symbol (tree);
 static void dbxout_finish_symbol (tree);
 static void dbxout_block (tree, int, tree);
@@ -2391,6 +2393,7 @@
 {
   int letter = 0;
   int regno = -1;
+  int offs;
 
   emit_pending_bincls_if_required ();
 
@@ -2454,7 +2457,15 @@
 	  if (DECL_INITIAL (decl) == 0
 	      || (!strcmp (lang_hooks.name, "GNU C++")
 		  && DECL_INITIAL (decl) == error_mark_node))
-	    current_sym_code = N_LCSYM;
+            {
+              current_sym_code = N_LCSYM;
+              if (NULL != dbxout_common_check (decl, &offs))
+                {
+                  current_sym_addr = 0;
+                  current_sym_value = offs;
+                  current_sym_code = N_GSYM;
+                }
+            }
 	  else if (DECL_IN_TEXT_SECTION (decl))
 	    /* This is not quite right, but it's the closest
 	       of all the codes that Unix defines.  */
@@ -2578,7 +2589,14 @@
 	 this variable was itself `static'.  */
       current_sym_code = N_LCSYM;
       letter = 'V';
-      current_sym_addr = XEXP (XEXP (home, 0), 0);
+      if (NULL == dbxout_common_check (decl, &offs))
+        current_sym_addr = XEXP (XEXP (home, 0), 0);
+      else
+        {
+         current_sym_addr = 0;
+          current_sym_value = offs;
+         current_sym_code = N_GSYM;
+        }
     }
   else if (GET_CODE (home) == CONCAT)
     {
@@ -2615,7 +2633,7 @@
 
   /* Ok, start a symtab entry and output the variable name.  */
   FORCE_TEXT;
-
+ 
 #ifdef DBX_STATIC_BLOCK_START
   DBX_STATIC_BLOCK_START (asmfile, current_sym_code);
 #endif
@@ -2627,6 +2645,7 @@
 #ifdef DBX_STATIC_BLOCK_END
   DBX_STATIC_BLOCK_END (asmfile, current_sym_code);
 #endif
+ 
   return 1;
 }
 
@@ -2659,6 +2678,104 @@
   if (letter)
     putc (letter, asmfile);
 }
+ 
+/* Output the common block name for DECL in a stabs.
+
+   Symbols in global common (.comm) get wrapped with an N_BCOMM/N_ECOMM pair
+   around each group of symbols in the same .comm area.  The N_GSYM stabs
+   that are emitted only contain the offset in the common area.  This routine
+   emits the N_BCOMM and N_ECOMM stabs. */
+
+static void
+dbxout_common_name (tree decl, const char *name, STAB_CODE_TYPE op)
+{
+  fprintf (asmfile, "%s\"%s", ASM_STABS_OP, name);
+  current_sym_addr = NULL_RTX;
+  current_sym_value = 0;
+  current_sym_code = op;
+  dbxout_finish_symbol (decl);
+}
+
+/* Check decl to determine whether it is a VAR_DECL destined for storage in a
+   common area.  If it is, the return value will be a non-null string giving
+   the name of the common storage block it will go into.  If non-null, the
+   value is the offset into the common block for that symbol's storage. */
+
+static const char *
+dbxout_common_check(tree decl, int *value)
+{
+  rtx home;
+  rtx sym_addr;
+  const char *name = NULL;
+
+  if (TREE_CODE (decl) != VAR_DECL
+      || !DECL_COMMON (decl)
+      || !TREE_STATIC (decl))
+    return NULL;
+
+  home = DECL_RTL (decl);
+  if (GET_CODE (home) != MEM)
+    return NULL;
+
+  sym_addr = XEXP (home, 0);
+  if (GET_CODE (sym_addr) == CONST)
+    sym_addr = XEXP (sym_addr, 0);
+  if ((GET_CODE (sym_addr) == SYMBOL_REF || GET_CODE (sym_addr) == PLUS)
+      && !TREE_PUBLIC (decl)
+      && (DECL_INITIAL (decl) == 0
+            || (!strcmp (lang_hooks.name, "GNU C++")
+                 && DECL_INITIAL (decl) == error_mark_node)))
+    {
+
+      /* We have sym that will go into a common area, meaning that it
+        will get storage reserved with a .comm/.lcomm assembler pseudo-op.
+
+         Determine name of common area this symbol will be an offset into,
+        and offset into that area.  Also retrieve the decl for the area
+        that the symbol is offset into. */
+      tree cdecl = NULL;
+
+      switch (GET_CODE (sym_addr))
+        {       
+          case PLUS:
+            if (GET_CODE (XEXP (sym_addr, 0)) == CONST_INT)
+              {
+                name =
+                 (* targetm.strip_name_encoding)(XSTR (XEXP (sym_addr, 1), 0));
+                *value = INTVAL (XEXP (sym_addr, 0));
+               cdecl = SYMBOL_REF_DECL (XEXP (sym_addr, 1));
+              }
+            else
+              {
+                name =
+                 (* targetm.strip_name_encoding)(XSTR (XEXP (sym_addr, 0), 0));
+                *value = INTVAL (XEXP (sym_addr, 1));
+               cdecl = SYMBOL_REF_DECL (XEXP (sym_addr, 0));
+              }
+            break;
+          
+          case SYMBOL_REF:
+            name = (* targetm.strip_name_encoding)(XSTR (sym_addr, 0));
+            *value = 0;
+           cdecl = SYMBOL_REF_DECL (sym_addr);
+            break;
+
+          default:
+            error ("common symbol debug info is not structured as "
+                  "symbol+offset");
+        }
+
+      /* Check area common symbol is offset into.  If this is not public, then
+        it is not a symbol in a common block.  It must be a .lcomm symbol, not
+        a .comm symbol.  */
+      if (cdecl == NULL || !TREE_PUBLIC(cdecl))
+       name = NULL;
+    }
+  else
+    name = NULL;
+
+  return name;
+}
 
 static void
 dbxout_prepare_symbol (tree decl ATTRIBUTE_UNUSED)
@@ -2697,18 +2814,45 @@
 #endif
 }
 
-/* Output definitions of all the decls in a chain. Return nonzero if
-   anything was output */
+/* Output definitions of all the decls in a chain.  Bracket each group of
+   common symbols with N_BCOMM/N_ECOMM bracketing stabs.  Return nonzero if
+   anything was output. */
 
 int
 dbxout_syms (tree syms)
 {
   int result = 0;
+  const char *comm_prev = NULL;
+  tree syms_prev = NULL;
   while (syms)
     {
+      int temp, copen, cclos;
+      const char *comm_new;
+
+      /* Check for common symbol, and then progression into a new/different
+        block of common symbols.  Emit closing/opening common bracket if
+        necessary. */
+      comm_new = dbxout_common_check (syms, &temp);
+      copen = comm_new != NULL
+             && (comm_prev == NULL || strcmp (comm_new, comm_prev));
+      cclos = comm_prev != NULL
+             && (comm_new == NULL || strcmp (comm_new, comm_prev));
+      if (cclos)
+       dbxout_common_name (syms, comm_prev, N_ECOMM);
+      if (copen)
+       {
+         dbxout_common_name (syms, comm_new, N_BCOMM);
+         syms_prev = syms;
+       }
+      comm_prev = comm_new;
+
       result += dbxout_symbol (syms, 1);
       syms = TREE_CHAIN (syms);
     }
+
+  if (comm_prev != NULL)
+    dbxout_common_name (syms_prev, comm_prev, N_ECOMM);
+
   return result;
 }
 
diff -ur gcc-3.4.3.orig/gcc/function.c gcc-3.4.3/gcc/function.c
--- ./gcc-3.4.3.orig/gcc/function.c	2004-10-14 00:18:13.000000000 +0100
+++ ./gcc-3.4.3/gcc/function.c	2007-10-07 12:37:07.000000000 +0100
@@ -290,7 +290,7 @@
 static void prepare_function_start (tree);
 static void do_clobber_return_reg (rtx, void *);
 static void do_use_return_reg (rtx, void *);
-static void instantiate_virtual_regs_lossage (rtx);
+static void instantiate_virtual_regs_lossage (rtx, const char *);
 static tree split_complex_args (tree);
 static void set_insn_locators (rtx, int) ATTRIBUTE_UNUSED;
 
@@ -3571,7 +3571,7 @@
 	   to avoid failures later in the compilation process.  */
         if (asm_noperands (PATTERN (insn)) >= 0
 	    && ! check_asm_operands (PATTERN (insn)))
-          instantiate_virtual_regs_lossage (insn);
+          instantiate_virtual_regs_lossage (insn, "scan");
       }
 
   /* Instantiate the stack slots for the parm registers, for later use in
@@ -3745,15 +3745,17 @@
    Usually this means that non-matching instruction has been emit, however for
    asm statements it may be the problem in the constraints.  */
 static void
-instantiate_virtual_regs_lossage (rtx insn)
+instantiate_virtual_regs_lossage (rtx insn, const char *note)
 {
   if (asm_noperands (PATTERN (insn)) >= 0)
     {
       error_for_asm (insn, "impossible constraint in `asm'");
       delete_insn (insn);
     }
-  else
+  else {
+    warning ("Lossage type is %s", note);
     abort ();
+  }
 }
 /* Given a pointer to a piece of rtx and an optional pointer to the
    containing object, instantiate any virtual registers present in it.
@@ -3830,7 +3832,7 @@
 	     the simplest possible thing to handle them.  */
 	  if (GET_CODE (src) != REG && GET_CODE (src) != PLUS)
 	    {
-	      instantiate_virtual_regs_lossage (object);
+	      instantiate_virtual_regs_lossage (object, "SET PLUS/REG");
 	      return 1;
 	    }
 
@@ -3848,7 +3850,7 @@
 
 	  if (! validate_change (object, &SET_SRC (x), temp, 0)
 	      || ! extra_insns)
-	    instantiate_virtual_regs_lossage (object);
+	    instantiate_virtual_regs_lossage (object, "SET SET_SRC");
 
 	  return 1;
 	}
@@ -3959,7 +3961,8 @@
 		  if (! validate_change (object, loc, temp, 0)
 		      && ! validate_replace_rtx (x, temp, object))
 		    {
-		      instantiate_virtual_regs_lossage (object);
+		      print_rtl_single (stderr, x);
+		      instantiate_virtual_regs_lossage (object, "PLUS");
 		      return 1;
 		    }
 		}
@@ -4028,7 +4031,9 @@
       if (temp == virtual_stack_vars_rtx
 	  || temp == virtual_incoming_args_rtx
 	  || (GET_CODE (temp) == PLUS
-	      && CONSTANT_ADDRESS_P (XEXP (temp, 1))
+	  /*  && CONSTANT_ADDRESS_P (XEXP (temp, 1))  ***GRH EDIT*** */
+	      && (CONSTANT_ADDRESS_P (XEXP (temp, 1))
+	          || CONSTANT_P (XEXP (temp, 1)))
 	      && (XEXP (temp, 0) == virtual_stack_vars_rtx
 		  || XEXP (temp, 0) == virtual_incoming_args_rtx)))
 	{
@@ -4117,7 +4122,7 @@
 	      emit_insn_before (seq, object);
 	      if (! validate_change (object, loc, temp, 0)
 		  && ! validate_replace_rtx (x, temp, object))
-	        instantiate_virtual_regs_lossage (object);
+	        instantiate_virtual_regs_lossage (object, "REGS");
 	    }
 	}
 
diff -ur gcc-3.4.3.orig/gcc/config/i386/i386.c gcc-3.4.3/gcc/config/i386/i386.c
--- ./gcc-3.4.3.orig/gcc/config/i386/i386.c	2004-08-25 06:19:08.000000000 +0100
+++ ./gcc-3.4.3/gcc/config/i386/i386.c	2007-10-07 14:37:06.000000000 +0100
@@ -5537,6 +5537,7 @@
   else if (GET_CODE (addr) == PLUS)
     {
       rtx addends[4], op;
+#if 0 /* *** GRH MODS *** */
       int n = 0, i;
 
       op = addr;
@@ -5548,6 +5549,23 @@
 	  op = XEXP (op, 0);
 	}
       while (GET_CODE (op) == PLUS);
+#else
+      int n = 0, i, adding = 1;
+
+      op = addr;
+      do
+	{
+	  if (n >= 4)
+	    return 0;
+	  if (GET_CODE (XEXP (op, 0)) == PLUS)
+	    addends[n++] = XEXP (op, 1), op = XEXP (op, 0);
+	  else if (GET_CODE (XEXP (op, 1)) == PLUS)
+	    addends[n++] = XEXP (op, 0), op = XEXP (op, 1);
+	  else
+	    adding = 0, addends[n++] = XEXP (op, 0), op = XEXP (op, 1);
+	}
+      while (adding);
+#endif
       if (n >= 4)
 	return 0;
       addends[n] = op;
@@ -5787,6 +5805,17 @@
 	  x = XEXP (x, 0);
 	}
 
+      /* Allow {LABEL | SYMBOL}_REF - SYMBOL_REF-FOR-PICBASE for Mach-O.  */
+      if (TARGET_MACHO && GET_CODE (x) == MINUS) {
+        if (GET_CODE (XEXP (x, 0)) == LABEL_REF ||
+            GET_CODE (XEXP (x, 0)) == SYMBOL_REF)
+          if (GET_CODE (XEXP (x, 1)) == SYMBOL_REF) {
+            const char *sym_name = XSTR (XEXP (x, 1), 0);
+            if (! strcmp (sym_name, "<pic base>"))
+              return true;
+          }
+      }
+
       /* Only some unspecs are valid as "constants".  */
       if (GET_CODE (x) == UNSPEC)
 	switch (XINT (x, 1))
@@ -15304,7 +15333,7 @@
     {
       fprintf (file, "\tcall LPC$%d\nLPC$%d:\tpopl %%eax\n", label, label);
       fprintf (file, "\tmovl %s-LPC$%d(%%eax),%%edx\n", lazy_ptr_name, label);
-      fprintf (file, "\tjmp %%edx\n");
+      fprintf (file, "\tjmp *%%edx\n");
     }
   else
     fprintf (file, "\tjmp *%s\n", lazy_ptr_name);
diff -ur gcc-3.4.3.orig/gcc/recog.c gcc-3.4.3/gcc/recog.c
--- ./gcc-3.4.3.orig/gcc/recog.c	2004-01-23 23:49:54.000000000 +0000
+++ ./gcc-3.4.3/gcc/recog.c	2007-10-07 14:39:51.000000000 +0100
@@ -260,14 +260,23 @@
 {
   rtx pat = PATTERN (insn);
   int num_clobbers = 0;
+
   /* If we are before reload and the pattern is a SET, see if we can add
      clobbers.  */
+#if 0 /* *** GRH MODS *** */
   int icode = recog (pat, insn,
 		     (GET_CODE (pat) == SET
 		      && ! reload_completed && ! reload_in_progress)
 		     ? &num_clobbers : 0);
   int is_asm = icode < 0 && asm_noperands (PATTERN (insn)) >= 0;
-
+#else
+  int icode, is_asm;
+  if (GET_CODE (pat) != SET || reload_completed || reload_in_progress)
+    icode = recog (pat, insn, 0);
+  else
+    icode = recog (pat, insn, &num_clobbers);
+  is_asm = icode < 0 && asm_noperands (PATTERN (insn)) >= 0;
+#endif
 
   /* If this is an asm and the operand aren't legal, then fail.  Likewise if
      this is not an asm and the insn wasn't recognized.  */
@@ -282,6 +291,7 @@
     {
       rtx newpat;
 
+#if !defined(__i386__) /* *** GRH MODS *** */
       if (added_clobbers_hard_reg_p (icode))
 	return 1;
 
@@ -289,6 +299,21 @@
       XVECEXP (newpat, 0, 0) = pat;
       add_clobbers (newpat, icode);
       PATTERN (insn) = pat = newpat;
+#else
+      /* Check whether clobber is due to CC register being affected by a SET
+         in an unoptimized routine.  If it is, we judge the clobber to be
+	 harmless and turn the insn into a parallel that declares the clobber.
+      */
+      if (added_clobbers_hard_reg_p (icode) && (num_clobbers > 1 || optimize))
+	return 1;
+
+      newpat = gen_rtx_PARALLEL (VOIDmode, rtvec_alloc (num_clobbers + 1));
+      XVECEXP (newpat, 0, 0) = pat;
+      add_clobbers (newpat, icode);
+      if (GET_MODE (XEXP (XVECEXP (newpat, 0, 1), 0)) != CCmode)
+        return 1;
+      PATTERN (insn) = pat = newpat;
+#endif
     }
 
   /* After reload, verify that all constraints are satisfied.  */
@@ -2079,8 +2104,14 @@
 	 and get the constraints.  */
 
       icode = recog_memoized (insn);
-      if (icode < 0)
-	fatal_insn_not_found (insn);
+      if (icode < 0) { /* *** GRH MOD *** */
+        /* Try re-recognizing with clobbers allowed. recog_memoized does not
+	   provide for handling of hard reg clobbers, so will not recognize
+	   an insn that generates one. */
+        if (insn_invalid_p (insn) ||
+            (icode = recog_memoized (insn)) < 0)
+	  fatal_insn_not_found (insn);
+      }
 
       recog_data.n_operands = noperands = insn_data[icode].n_operands;
       recog_data.n_alternatives = insn_data[icode].n_alternatives;
diff -ur gcc-3.4.3.orig/gcc/xcoffout.h gcc-3.4.3/gcc/xcoffout.h
--- ./gcc-3.4.3.orig/gcc/xcoffout.h	2003-07-06 17:53:23.000000000 +0100
+++ ./gcc-3.4.3/gcc/xcoffout.h	2007-10-07 12:37:07.000000000 +0100
@@ -97,7 +97,7 @@
     }								\
   else if (current_sym_addr)					\
     output_addr_const (asmfile, current_sym_addr);		\
-  else if (current_sym_code == N_GSYM)				\
+  else if (current_sym_code == N_GSYM && TREE_PUBLIC (SYM))     \
     assemble_name (asmfile, XSTR (XEXP (DECL_RTL (sym), 0), 0)); \
   else								\
     fprintf (asmfile, "%d", current_sym_value);			\
diff -u {/tmp,.}/configure.ac
--- ./gcc-3.4.3/gcc/configure.ac.orig	2004-09-24 01:43:53.000000000 +0100
+++ ./gcc-3.4.3/gcc/configure.ac	2007-12-29 22:41:24.000000000 +0000
@@ -918,6 +918,12 @@
 #endif
 ])
 
+gcc_AC_CHECK_DECLS(sigaltstack, , ,[
+#include "ansidecl.h"
+#include "system.h"
+#include <signal.h>
+])
+
 # More time-related stuff.
 AC_CACHE_CHECK(for struct tms, ac_cv_struct_tms, [
 AC_TRY_COMPILE([
@@ -1108,6 +1114,24 @@
 	fi
 fi
 
+case ${host} in
+  powerpc-*-darwin*)
+    AC_CACHE_CHECK([whether mcontext_t fields have underscores],
+      gcc_cv_mcontext_underscores,
+      AC_COMPILE_IFELSE([
+#include <sys/types.h>
+#include <sys/signal.h>
+#include <ucontext.h>
+int main() { mcontext_t m; if (m->ss.srr0) return 0; return 0; }
+],
+        gcc_cv_mcontext_underscores=no, gcc_cv_mcontext_underscores=yes))
+      if test $gcc_cv_mcontext_underscores = yes; then
+        AC_DEFINE(HAS_MCONTEXT_T_UNDERSCORES,,dnl
+          [mcontext_t fields start with __])
+      fi
+    ;;
+esac
+
 # Check if a valid thread package
 case ${enable_threads_flag} in
   "" | no)
diff -ur ./gcc-3.4.3/gcc/config/rs6000/host-darwin.c{.orig,}
--- ./gcc-3.4.3/gcc/config/rs6000/host-darwin.c.orig	2003-07-30 00:36:53.000000000 +0100
+++ ./gcc-3.4.3/gcc/config/rs6000/host-darwin.c	2007-12-28 22:38:17.000000000 +0000
@@ -33,9 +33,19 @@
 static void segv_handler (int, siginfo_t *, void *);
 static void darwin_rs6000_extra_signals (void);
 
+#ifndef HAVE_DECL_SIGALTSTACK
 /* This doesn't have a prototype in signal.h in 10.2.x and earlier,
    fixed in later releases.  */
 extern int sigaltstack(const struct sigaltstack *, struct sigaltstack *);
+#endif
+
+/* The fields of the mcontext_t type have acquired underscores in later
+   OS versions.  */
+#ifdef HAS_MCONTEXT_T_UNDERSCORES
+#define MC_FLD(x) __ ## x
+#else
+#define MC_FLD(x) x
+#endif
 
 #undef HOST_HOOKS_EXTRA_SIGNALS
 #define HOST_HOOKS_EXTRA_SIGNALS darwin_rs6000_extra_signals
@@ -64,7 +74,7 @@
      which case the next line will segfault _again_.  Handle this case.  */
   signal (SIGSEGV, segv_crash_handler);
 
-  faulting_insn = *(unsigned *)uc->uc_mcontext->ss.srr0;
+  faulting_insn = *(unsigned *)uc->uc_mcontext->MC_FLD(ss).MC_FLD(srr0);
 
   /* Note that this only has to work for GCC, so we don't have to deal
      with all the possible cases (GCC has no AltiVec code, for
@@ -113,7 +123,8 @@
     }
 
   fprintf (stderr, "[address=%08lx pc=%08x]\n", 
-	   uc->uc_mcontext->es.dar, uc->uc_mcontext->ss.srr0);
+	   uc->uc_mcontext->MC_FLD(es).MC_FLD(dar),
+	   uc->uc_mcontext->MC_FLD(ss).MC_FLD(srr0));
   internal_error ("Segmentation Fault");
   exit (FATAL_EXIT_CODE);
 }
