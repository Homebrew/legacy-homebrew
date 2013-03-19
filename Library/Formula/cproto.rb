require 'formula'

class Cproto < Formula
  homepage 'http://cproto.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/cproto/cproto/4.6/cproto-4.6.tar.gz'
  sha1 '9d0d9e4280870c506f35aaa85a5160b95a09abb2'

  depends_on 'byacc'
  depends_on 'flex'

  def patches
    # Prefere byacc to bison
    DATA
  end

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "false"
  end
end

__END__
--- a/configure	1998-01-24 02:44:22.000000000 +0100
+++ b/configure	2013-03-19 23:28:35.000000000 +0100
@@ -862,7 +862,7 @@
   SET_MAKE="MAKE=${MAKE-make}"
 fi
 
-for ac_prog in 'bison -y' byacc
+for ac_prog in byacc 'bison -y'
 do
 # Extract the first word of "$ac_prog", so it can be a program name with args.
 set dummy $ac_prog; ac_word=$2
--- cproto-4.6/grammar.y.orig	Tue Jan 20 19:55:55 1998
+++ cproto-4.6/grammar.y	Mon Aug 13 18:39:07 2001
@@ -835,6 +835,7 @@
 	"__const__",    "__const",
 	"__volatile__", "__volatile",
 	"__inline__",   "__inline",
+	"__builtin_va_list",
 #endif
     };
     int i;
