require 'formula'

class Doxygen < Formula
  homepage 'http://www.doxygen.org/'
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.5.src.tar.gz'
  mirror 'http://downloads.sourceforge.net/project/doxygen/rel-1.8.5/doxygen-1.8.5.src.tar.gz'
  sha1 '1fc5ceec21122fe5037edee4c308ac94b59ee33e'

  head 'https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk'

  option 'with-dot', 'Build with dot command support from Graphviz.'
  option 'with-doxywizard', 'Build GUI frontend with qt support.'
  option 'with-libclang', 'Build with libclang support.'

  depends_on 'graphviz' if build.with? 'dot'
  depends_on 'qt' if build.with? 'doxywizard'
  depends_on 'llvm' => 'with-clang' if build.with? 'libclang'

  def patches
    DATA if build.with? 'doxywizard'
  end

  def install
    args = ["--prefix", prefix]
    args << '--with-libclang' if build.with? 'libclang'
    args << '--with-doxywizard' if build.with? 'doxywizard'
    system "./configure", *args
    # Per Macports:
    # https://trac.macports.org/browser/trunk/dports/textproc/doxygen/Portfile#L92
    inreplace %w[ libmd5/Makefile.libmd5
                  src/Makefile.libdoxycfg
                  tmake/lib/macosx-c++/tmake.conf
                  tmake/lib/macosx-intel-c++/tmake.conf
                  tmake/lib/macosx-uni-c++/tmake.conf ] do |s|
      # otherwise clang may use up large amounts of RAM while
      # processing localization files
      # gcc doesn't support the flag
      s.gsub! '-Wno-invalid-source-encoding', '' unless ENV.compiler == :clang
      # makefiles hardcode both cc and c++
      s.gsub! /cc$/, ENV.cc
      s.gsub! /c\+\+$/, ENV.cxx
    end

    # This is a terrible hack; configure finds lex/yacc OK but
    # one Makefile doesn't get generated with these, so pull
    # them out of a known good file and cram them into the other.
    lex = ''
    yacc = ''

    inreplace 'src/libdoxycfg.t' do |s|
      lex = s.get_make_var 'LEX'
      yacc = s.get_make_var 'YACC'
    end

    inreplace 'src/Makefile.libdoxycfg' do |s|
      s.change_make_var! 'LEX', lex
      s.change_make_var! 'YACC', yacc
    end

    system "make"
    # MAN1DIR, relative to the given prefix
    system "make", "MAN1DIR=share/man/man1", "install"
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
