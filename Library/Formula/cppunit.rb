require 'formula'

class Cppunit < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/cppunit/'
  url 'https://downloads.sourceforge.net/project/cppunit/cppunit/1.12.1/cppunit-1.12.1.tar.gz'
  sha1 'f1ab8986af7a1ffa6760f4bacf5622924639bf4a'

  bottle do
    cellar :any
    sha1 "2454890509b3b673e6a2bc7f53d755df7d5abb8f" => :mavericks
    sha1 "07ace28a30f222a55adc2cd351524e5c8d8783a1" => :mountain_lion
    sha1 "fcc7a7f99e35235a8cee728a3165d0db4da5dd5c" => :lion
  end

  option :universal

  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

# configure script is broken, the final rm -f fails because it tries to file
# delete a directory. superenv exposes this bug for some reason, but std-env
# does not. Weird.
__END__
diff --git a/configure b/configure
index 424eea6..11e73ad 100755
--- a/configure
+++ b/configure
@@ -23318,5 +23318,5 @@ echo X/* automatically generated */ |
 echo "$as_me: error: input file $ac_prefix_conf_IN does not exist,     skip generating $ac_prefix_conf_OUT" >&2;}
    { (exit 1); exit 1; }; }
   fi
-  rm -f conftest.*
+  rm -f conftest.* || true
 fi
