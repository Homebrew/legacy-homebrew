require 'formula'

class Clang < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.1/clang-3.1.src.tar.gz'
  sha1      '19f33b187a50d22fda2a6f9ed989699a9a9efd62'

  head      'http://llvm.org/git/clang.git'
end

class Llvm < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.1/llvm-3.1.src.tar.gz'
  sha1      '234c96e73ef81aec9a54da92fc2a9024d653b059'

  head      'http://llvm.org/git/llvm.git'

  bottle do
    sha1 'fcf6c3eb5b074afa820f905f32182e074a29ffb5' => :mountainlion
    sha1 '4ee3e9242cff9a03af4e1f20017fe547dcd07a4a' => :lion
    sha1 '940aca37dafaf69a9b378ffd2a59b3c1cfe54ced' => :snowleopard
  end

  def patches
    # fix generation of ocaml bindings (essentially by switching the order of compilation between docs and bindings)
    DATA
  end

  def options
    [['--with-clang', 'Build clang C/ObjC/C++ frontend'],
     ['--shared', 'Build llvm as shared library, and link tools against it'],
     ['--all-targets', 'Build all target backends'],
     ['--rtti', 'Build llvm with C++ RTTI, use if you need RTTI of llvm classes'],
     ['--universal', 'Build both i386 and x86_64 architectures']]
  end

  def install
    if ARGV.include? '--shared' && ARGV.build_universal?
      onoe "Cannot specify both shared and universal (will not build)"
      exit 1
    end

    Clang.new("clang").brew { clang_dir.install Dir['*'] } if ARGV.include? '--with-clang'

    if ARGV.build_universal?
      ENV['UNIVERSAL'] = '1'
      ENV['UNIVERSAL_ARCH'] = 'i386 x86_64'
    end

    ENV['REQUIRES_RTTI'] = '1' if ARGV.include? '--rtti'

    configure_options = [
      "--prefix=#{prefix}",
      "--enable-optimized",
      # As of LLVM 3.1, attempting to build ocaml bindings with Homebrew's
      # OCaml 3.12.1 results in errors.
      # *** This should be fixed now. See commented patch. ***
      # "--disable-bindings",
    ]

    if ARGV.include? '--all-targets'
      configure_options << "--enable-targets=all"
    else
      configure_options << "--enable-targets=host"
    end
    configure_options << "--enable-shared" if ARGV.include? '--shared'

    system "./configure", *configure_options
    system "make install"

    # install llvm python bindings
    (share/'llvm/bindings').install buildpath/'bindings/python'

    # install clang tools and bindings
    cd clang_dir do
      (share/'clang/tools').install 'tools/scan-build', 'tools/scan-view'
      (share/'clang/bindings').install 'bindings/python'
    end if ARGV.include? '--with-clang'
  end

  def test
    system "#{bin}/llvm-config", "--version"
  end

  def caveats; <<-EOS.undent
    Extra tools and bindings are installed in #{share}/llvm and #{share}/clang.

    If you already have LLVM installed, then "brew upgrade llvm" might not work.
    Instead, try:
        brew rm llvm && brew install llvm
    EOS
  end

  def clang_dir
    buildpath/'tools/clang'
  end
end
__END__
diff --git a/bindings/ocaml/Makefile b/bindings/ocaml/Makefile
index a89caef..b67840a 100644
--- a/bindings/ocaml/Makefile
+++ b/bindings/ocaml/Makefile
@@ -11,9 +11,9 @@ LEVEL := ../..
 DIRS = llvm bitreader bitwriter analysis target executionengine transforms
 ExtraMakefiles = $(PROJ_OBJ_DIR)/Makefile.ocaml
 
-ocamldoc:
+include $(LEVEL)/Makefile.common
+
+ocamldoc:
 	$(Verb) for i in $(DIRS) ; do \
 		$(MAKE) -C $$i ocamldoc; \
 	done
-
-include $(LEVEL)/Makefile.common
diff --git a/bindings/ocaml/transforms/Makefile b/bindings/ocaml/transforms/Makefile
index 05fcd90..3b6064b 100644
--- a/bindings/ocaml/transforms/Makefile
+++ b/bindings/ocaml/transforms/Makefile
@@ -10,9 +10,9 @@
 LEVEL := ../../..
 DIRS = scalar ipo
 
-ocamldoc:
+include $(LEVEL)/Makefile.common
+
+ocamldoc:
 	$(Verb) for i in $(DIRS) ; do \
 		$(MAKE) -C $$i ocamldoc; \
 	done
-
-include $(LEVEL)/Makefile.common
diff --git a/Makefile b/Makefile
index ec24862..a10e3c0 100644
--- a/Makefile
+++ b/Makefile
@@ -31,8 +31,8 @@ ifeq ($(BUILD_DIRS_ONLY),1)
   OPTIONAL_DIRS := tools/clang/utils/TableGen
 else
   DIRS := lib/Support lib/TableGen utils lib/VMCore lib tools/llvm-shlib \
-          tools/llvm-config tools runtime docs unittests
-  OPTIONAL_DIRS := projects bindings
+          tools/llvm-config tools runtime unittests
+  OPTIONAL_DIRS := projects bindings docs
 endif
 
 ifeq ($(BUILD_EXAMPLES),1)
@@ -48,21 +48,21 @@ ifneq ($(ENABLE_SHARED),1)
 endif
 
 ifneq ($(ENABLE_DOCS),1)
-  DIRS := $(filter-out docs, $(DIRS))
+  OPTIONAL_DIRS := $(filter-out docs, $(OPTIONAL_DIRS))
 endif
 
 ifeq ($(MAKECMDGOALS),libs-only)
-  DIRS := $(filter-out tools runtime docs, $(DIRS))
+  DIRS := $(filter-out tools runtime, $(DIRS))
   OPTIONAL_DIRS :=
 endif
 
 ifeq ($(MAKECMDGOALS),install-libs)
-  DIRS := $(filter-out tools runtime docs, $(DIRS))
-  OPTIONAL_DIRS := $(filter bindings, $(OPTIONAL_DIRS))
+  DIRS := $(filter-out tools runtime, $(DIRS))
+  OPTIONAL_DIRS := $(filter bindings docs, $(OPTIONAL_DIRS))
 endif
 
 ifeq ($(MAKECMDGOALS),tools-only)
-  DIRS := $(filter-out runtime docs, $(DIRS))
+  DIRS := $(filter-out runtime, $(DIRS))
   OPTIONAL_DIRS :=
 endif
 
@@ -77,13 +77,13 @@ ifeq ($(MAKECMDGOALS),install-clang)
 endif
 
 ifeq ($(MAKECMDGOALS),clang-only)
-  DIRS := $(filter-out tools docs unittests, $(DIRS)) \
+  DIRS := $(filter-out tools unittests, $(DIRS)) \
           tools/clang tools/lto
   OPTIONAL_DIRS :=
 endif
 
 ifeq ($(MAKECMDGOALS),unittests)
-  DIRS := $(filter-out tools runtime docs, $(DIRS)) utils unittests
+  DIRS := $(filter-out tools runtime, $(DIRS)) utils unittests
   OPTIONAL_DIRS :=
 endif
 
