require 'formula'

class Alpine < Formula
  homepage 'http://www.washington.edu/alpine/'
  url 'ftp://ftp.cac.washington.edu/alpine/alpine-2.00.tar.gz'
  sha1 '363b3aa5d3eb1319e168639fbbc42b033b16f15b'

  # Upstream builds are broken on Snow Leopard due to a hack put in for prior
  # versions of OS X. See: http://trac.macports.org/ticket/20971
  patch do
    url "https://trac.macports.org/export/89747/trunk/dports/mail/alpine/files/alpine-osx-10.6.patch"
    sha1 "8cc6b95b6aba844ceef8454868b8f2c205de9792"
  end

  # Fails to build against Tcl 8.6; reported upstream:
  # http://mailman2.u.washington.edu/pipermail/alpine-info/2013-September/005291.html
  patch :DATA

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ssl-include-dir=/usr/include/openssl"
    system "make install"
  end
end

__END__
diff --git a/web/src/alpined.d/alpined.c b/web/src/alpined.d/alpined.c
index 98c5a63..d2c63b5 100644
--- a/web/src/alpined.d/alpined.c
+++ b/web/src/alpined.d/alpined.c
@@ -751,10 +751,10 @@ main(int argc, char *argv[])
 				}
 
 				switch(Tcl_Eval(interp, &buf[co])){
-				  case TCL_OK	  : peReturn(cs, "OK", interp->result); break;
-				  case TCL_ERROR  : peReturn(cs, "ERROR", interp->result); break;
-				  case TCL_BREAK  : peReturn(cs, "BREAK", interp->result); break;
-				  case TCL_RETURN : peReturn(cs, "RETURN", interp->result); break;
+				  case TCL_OK	  : peReturn(cs, "OK",  Tcl_GetStringResult(interp)); break;
+				  case TCL_ERROR  : peReturn(cs, "ERROR", Tcl_GetStringResult(interp)); break;
+				  case TCL_BREAK  : peReturn(cs, "BREAK", Tcl_GetStringResult(interp)); break;
+				  case TCL_RETURN : peReturn(cs, "RETURN", Tcl_GetStringResult(interp)); break;
 				  default	  : peReturn(cs, "BOGUS", "eval returned unexpected value"); break;
 				}
 			    }

