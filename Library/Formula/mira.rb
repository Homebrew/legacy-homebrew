require 'formula'

class Mira < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/mira-assembler/'
  url 'http://downloads.sourceforge.net/project/mira-assembler/MIRA/stable/mira-3.4.0.2.tar.bz2'
  sha1 'bf40ce540cdd794d0a1653b5fb829ab2b0829198'


  depends_on 'boost'
  depends_on 'google-perftools'
  depends_on 'docbook'

  # Fix a compiler error on OS X 10.8
  # http://www.freelists.org/post/mira_talk/Type-mismatch-of-LexerInput-and-LexerOutput-PATCH
  def patches
    DATA if MacOS.version >= :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Link with boost_system for boost::system::system_category().
    # http://www.freelists.org/post/mira_talk/Linking-requires-boost-system
    system "make LIBS=-lboost_system-mt install"
  end

  def test
    system "#{bin}/mira"
  end
end

__END__
diff -ur a/src/EdIt/parameters_flexer.cc b/src/EdIt/parameters_flexer.cc
--- a/src/EdIt/parameters_flexer.cc	2012-08-29 10:33:02.000000000 -0700
+++ b/src/EdIt/parameters_flexer.cc	2012-10-22 10:58:26.000000000 -0700
@@ -1367,9 +1367,9 @@
 }

 #ifdef YY_INTERACTIVE
-int yyFlexLexer::LexerInput( char* buf, int /* max_size */ )
+size_t yyFlexLexer::LexerInput( char* buf, size_t /* max_size */ )
 #else
-int yyFlexLexer::LexerInput( char* buf, int max_size )
+size_t yyFlexLexer::LexerInput( char* buf, size_t max_size )
 #endif
 {
	if ( yyin->eof() || yyin->fail() )
@@ -1396,7 +1396,7 @@
 #endif
 }

-void yyFlexLexer::LexerOutput( const char* buf, int size )
+void yyFlexLexer::LexerOutput( const char* buf, size_t size )
 {
	(void) yyout->write( buf, size );
 }
diff -ur a/src/caf/caf_flexer.cc b/src/caf/caf_flexer.cc
--- a/src/caf/caf_flexer.cc	2012-08-29 10:33:02.000000000 -0700
+++ b/src/caf/caf_flexer.cc	2012-10-22 10:58:58.000000000 -0700
@@ -2291,9 +2291,9 @@
 }

 #ifdef YY_INTERACTIVE
-int yyFlexLexer::LexerInput( char* buf, int /* max_size */ )
+size_t yyFlexLexer::LexerInput( char* buf, size_t /* max_size */ )
 #else
-int yyFlexLexer::LexerInput( char* buf, int max_size )
+size_t yyFlexLexer::LexerInput( char* buf, size_t max_size )
 #endif
 {
	if ( yyin->eof() || yyin->fail() )
@@ -2320,7 +2320,7 @@
 #endif
 }

-void yyFlexLexer::LexerOutput( const char* buf, int size )
+void yyFlexLexer::LexerOutput( const char* buf, size_t size )
 {
	(void) yyout->write( buf, size );
 }
diff -ur a/src/io/exp_flexer.cc b/src/io/exp_flexer.cc
--- a/src/io/exp_flexer.cc	2012-08-29 10:33:01.000000000 -0700
+++ b/src/io/exp_flexer.cc	2012-10-22 10:55:35.000000000 -0700
@@ -1405,9 +1405,9 @@
 }

 #ifdef YY_INTERACTIVE
-int yyFlexLexer::LexerInput( char* buf, int /* max_size */ )
+size_t yyFlexLexer::LexerInput( char* buf, size_t /* max_size */ )
 #else
-int yyFlexLexer::LexerInput( char* buf, int max_size )
+size_t yyFlexLexer::LexerInput( char* buf, size_t max_size )
 #endif
 {
	if ( yyin->eof() || yyin->fail() )
@@ -1434,7 +1434,7 @@
 #endif
 }

-void yyFlexLexer::LexerOutput( const char* buf, int size )
+void yyFlexLexer::LexerOutput( const char* buf, size_t size )
 {
	(void) yyout->write( buf, size );
 }
diff -ur a/src/mira/parameters_flexer.cc b/src/mira/parameters_flexer.cc
--- a/src/mira/parameters_flexer.cc	2012-08-29 10:33:02.000000000 -0700
+++ b/src/mira/parameters_flexer.cc	2012-10-22 10:57:50.000000000 -0700
@@ -7310,9 +7310,9 @@
 }

 #ifdef YY_INTERACTIVE
-int yyFlexLexer::LexerInput( char* buf, int /* max_size */ )
+size_t yyFlexLexer::LexerInput( char* buf, size_t /* max_size */ )
 #else
-int yyFlexLexer::LexerInput( char* buf, int max_size )
+size_t yyFlexLexer::LexerInput( char* buf, size_t max_size )
 #endif
 {
	if ( yyin->eof() || yyin->fail() )
@@ -7339,7 +7339,7 @@
 #endif
 }

-void yyFlexLexer::LexerOutput( const char* buf, int size )
+void yyFlexLexer::LexerOutput( const char* buf, size_t size )
 {
	(void) yyout->write( buf, size );
 }
