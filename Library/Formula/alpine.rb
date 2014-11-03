require "formula"

class Alpine < Formula
  homepage "http://patches.freeiz.com/alpine/release/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.11.tar.xz"
  mirror "https://www.mpeters.org/mirror/alpine-2.11.tar.xz"
  sha1 "656556f5d2e5ec7e3680d1760cd02aa3a0072c46"

  # Patch for Alpine 2.11 to fix compile issues
  # Adapted from https://trac.macports.org/ticket/38091
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Alpine/alpine-2.11_patch.diff"
    sha1 "cf280a0354673ea8aa1ee7834dc066a1732df549"
  end

  # Fails to build against Tcl 8.6; reported upstream:
  # http://mailman2.u.washington.edu/pipermail/alpine-info/2013-September/005291.html
  # Bug still present in 2.11.
  patch :DATA

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    ENV.j1
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-ssl-include-dir=#{Formula["openssl"].opt_prefix}/include/openssl",
                          "--with-ssl-lib-dir=#{Formula["openssl"].opt_prefix}/lib",
                          "--with-ssl-certs-dir=#{etc}/openssl/certs"
    system "make", "install"
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

