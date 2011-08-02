require 'formula'

class Icu4c < Formula
  url 'http://download.icu-project.org/files/icu4c/4.4.1/icu4c-4_4_1-src.tgz'
  homepage 'http://site.icu-project.org/'
  md5 'b6bc0a1153540b2088f8b03e0ba625d3'
  version "4.4.1"

  def patches
    DATA
  end

  keg_only "Conflicts; see: https://github.com/mxcl/homebrew/issues/issue/167"

  def install
    ENV.append "LDFLAGS", "-headerpad_max_install_names"
    config_flags = ["--prefix=#{prefix}", "--disable-samples", "--enable-static"]
    config_flags << "--with-library-bits=64" if MacOS.prefer_64_bit?
    Dir.chdir "source" do
      system "./configure", *config_flags
      system "make"
      system "make install"
    end
  end
end


__END__
--- a/source/configure	2009-07-02 03:51:26.000000000 +0900
+++ b/source/configure	2009-08-16 16:15:49.000000000 +0900
@@ -7058,11 +7058,8 @@
 	 test ! -s conftest.err
        } && test -s conftest.$ac_objext; then

-	# Check for potential -arch flags.  It is not universal unless
-	# there are some -arch flags.  Note that *ppc* also matches
-	# ppc64.  This check is also rather less than ideal.
 	case "${CC} ${CFLAGS} ${CPPFLAGS} ${LDFLAGS}" in  #(
-	  *-arch*ppc*|*-arch*i386*|*-arch*x86_64*) ac_cv_c_bigendian=universal;;
+	  *-arch*ppc*) ac_cv_c_bigendian=yes;;
 	esac
 else
   $as_echo "$as_me: failed program was:" >&5
