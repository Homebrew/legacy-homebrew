class Doxygen < Formula
  homepage "http://www.doxygen.org/"
  head "https://github.com/doxygen/doxygen.git"
  url "http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.9.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.9/doxygen-1.8.9.src.tar.gz"
  sha1 "b447251d32343ecf867f0a20cb63da4b478bfbab"

  bottle do
    cellar :any
    sha1 "eafc0d0538c3fab13d59d019b7050440eabbd34f" => :yosemite
    sha1 "8525a07222e6d674ca831e431d23d9df8ed327f2" => :mavericks
    sha1 "86a99e57afefcb69476b5a13012bef6009e60be2" => :mountain_lion
  end

  option "with-dot", "Build with dot command support from Graphviz."
  option "with-doxywizard", "Build GUI frontend with qt support."
  option "with-libclang", "Build with libclang support."

  depends_on "graphviz" if build.with? "dot"
  depends_on "qt" if build.with? "doxywizard"
  depends_on "llvm" => "with-clang" if build.with? "libclang"

  # Fixes for --with-doxywizard and --with-libclang
  patch :DATA

  def install
    args = ["--prefix", prefix]

    if build.with? "doxywizard"
      args << "--with-doxywizard"
      ENV["QTDIR"] = Formula["qt"].opt_prefix
    end

    if build.with? "libclang"
      args << "--with-libclang-static"
      llvm = Formula["llvm"]
      inreplace "configure" do |s|
        s.gsub! /libclang_hdr_dir=\".*$/, "libclang_hdr_dir=\"#{llvm.opt_include}\""
        s.gsub! /libclang_lib_dir=\".*$/, "libclang_lib_dir=\"#{llvm.opt_lib}\""
      end
    end

    system "./configure", *args

    # Per MacPorts:
    # https://trac.macports.org/browser/trunk/dports/textproc/doxygen/Portfile#L92
    inreplace %w[ tmake/lib/macosx-c++/tmake.conf
                  tmake/lib/macosx-intel-c++/tmake.conf
                  tmake/lib/macosx-uni-c++/tmake.conf ] do |s|
      # makefiles hardcode both cc and c++
      s.gsub! /cc$/, ENV.cc
      s.gsub! /c\+\+$/, ENV.cxx
    end

    # This is a terrible hack; configure finds lex/yacc OK but
    # one Makefile doesn't get generated with these, so pull
    # them out of a known good file and cram them into the other.
    lex = ""
    yacc = ""

    inreplace "src/libdoxycfg.t" do |s|
      lex = s.get_make_var "LEX"
      yacc = s.get_make_var "YACC"
    end

    system "make"
    # MAN1DIR, relative to the given prefix
    system "make", "MAN1DIR=share/man/man1", "install"
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end

__END__
# On Mac OS Qt builds an application bundle rather than a binary.  We need to
# give install the correct path to the doxywizard binary.  This is similar to
# what macports does:
diff --git a/addon/doxywizard/Makefile.in b/addon/doxywizard/Makefile.in
index 727409a..8b0d00f 100644
--- a/addon/doxywizard/Makefile.in
+++ b/addon/doxywizard/Makefile.in
@@ -30,7 +30,7 @@ distclean: Makefile.doxywizard
 
 install:
 	$(INSTTOOL) -d $(INSTALL)/bin	
-	$(INSTTOOL) -m 755 ../../bin/doxywizard $(INSTALL)/bin	
+	$(INSTTOOL) -m 755 ../../bin/doxywizard.app/Contents/MacOS/doxywizard $(INSTALL)/bin
 	$(INSTTOOL) -d $(INSTALL)/$(MAN1DIR)
 	cat ../../doc/doxywizard.1 | sed -e "s/DATE/$(DATE)/g" -e "s/VERSION/$(VERSION)/g" > doxywizard.1
 	$(INSTTOOL) -m 644 doxywizard.1 $(INSTALL)/$(MAN1DIR)/doxywizard.1
# Additional libraries needed to link clang
diff --git a/configure b/configure
index 1020492..c88a012 100755
--- a/configure
+++ b/configure
@@ -578,7 +578,7 @@ if test "$f_libclang" = YES; then
           if test "$f_libclangstatic" = NO; then
             libclang_link="-L $i -lclang"
           else
-            libclang_link="$i/libclang.a $i/libclangFrontend.a $i/libclangSerialization.a $i/libclangParse.a $i/libclangSema.a $i/libclangAnalysis.a $i/libclangStaticAnalyzerCore.a $i/libclangAST.a $i/libclangBasic.a $i/libclangDriver.a $i/libclangEdit.a $i/libclangLex.a $i/libclangRewriteCore.a $i/libLLVMBitReader.a $i/libLLVMMC.a $i/libLLVMMCParser.a $i/libLLVMSupport.a -ldl -lpthread"
+            libclang_link="$i/libclang.a $i/libclangFrontend.a $i/libclangSerialization.a $i/libclangParse.a $i/libclangSema.a $i/libclangAnalysis.a $i/libclangStaticAnalyzerCore.a $i/libclangAST.a $i/libclangBasic.a $i/libclangDriver.a $i/libclangEdit.a $i/libclangFormat.a $i/libclangLex.a $i/libclangRewrite.a $i/libclangTooling.a $i/libLLVMBitReader.a $i/libLLVMMC.a $i/libLLVMMCParser.a $i/libLLVMSupport.a $i/libClangIndex.a -ldl -lpthread -lncurses -lLLVM-3.5 -lz"
           fi
           break
         fi
