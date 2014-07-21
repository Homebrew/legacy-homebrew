require 'formula'

class NordugridArc < Formula
  homepage 'http://www.nordugrid.org'
  url 'http://download.nordugrid.org/packages/nordugrid-arc/releases/4.1.0/src/nordugrid-arc-4.1.0.tar.gz'
  sha1 '9836793b91b31d3c24ae5b0200aba2a56530e7e7'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'glibmm'
  depends_on 'libxml2'
  depends_on 'globus-toolkit'

  fails_with :clang do
    build 500
    cause "Fails with 'template specialization requires 'template<>''"
  end

  # See http://bugzilla.nordugrid.org/cgi-bin/bugzilla/show_bug.cgi?id=3366
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    (testpath/'foo').write('data')
    system "#{bin}/arccp", "foo", "bar"
  end
end

__END__
diff --git a/src/services/ldap-infosys/giis/Index.h b/src/services/ldap-infosys/giis/Index.h
index 7e91cd3..64fb30a 100644
--- a/src/services/ldap-infosys/giis/Index.h
+++ b/src/services/ldap-infosys/giis/Index.h
@@ -3,6 +3,7 @@

 #include <list>
 #include <string>
+#include <pthread.h>

 #include "Policy.h"
 #include "Entry.h"
