require 'formula'

class Gobby < Formula
  homepage 'http://gobby.0x539.de'
  url 'http://releases.0x539.de/gobby/gobby-0.4.94.tar.gz'
  sha1 '921979da611601ee6e220e2396bd2c86f0fb8c66'

  head 'git://git.0x539.de/git/gobby.git'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gtkmm'
  depends_on 'libgsasl'
  depends_on 'libxml++'
  depends_on 'gtksourceview'
  depends_on 'obby'
  depends_on 'gettext'
  depends_on 'hicolor-icon-theme'
  depends_on 'libinfinity'
  depends_on :x11

  def patches
    { :p0 => [ # Fix compilation on clang per MacPorts
      "https://trac.macports.org/export/101720/trunk/dports/x11/gobby/files/patch-code-util-config.hpp.diff"
    ], :p1 => DATA } # Fix gtkmm issues
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/code/util/config.hpp b/code/util/config.hpp
index 61c0cf4..7fcfe46 100644
--- a/code/util/config.hpp
+++ b/code/util/config.hpp
@@ -23,6 +23,7 @@
 
 #include <map>
 #include <memory>
+#include <glibmm.h>
 #include <glibmm/error.h>
 #include <glibmm/ustring.h>
 #include <gdkmm/color.h>
diff --git a/code/util/color.hpp b/code/util/color.hpp
index 476a26c..8fad8b1 100644
--- a/code/util/color.hpp
+++ b/code/util/color.hpp
@@ -18,7 +18,7 @@
 
 #ifndef _GOBBY_COLORUTIL_HPP_
 #define _GOBBY_COLORUTIL_HPP_
-
+#include <glibmm.h>
 #include <gdkmm/color.h>
 
 namespace Gobby
