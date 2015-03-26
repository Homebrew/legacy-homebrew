require "formula"

class Libtelnet < Formula
  homepage "https://github.com/seanmiddleditch/libtelnet"
  url "http://github.com/seanmiddleditch/libtelnet/tarball/0.21"
  sha256 "add20e5dcb55c26148c99201f986238f4a877202a023ba60ccb14b4d1bc1e9be"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "zlib" => :recommended

  stable do
    patch :DATA
  end

  def install
    system "autoreconf", "--install", "--force"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 7f5bb61..021b48f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,7 @@ AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([libtelnet.c])
 AM_INIT_AUTOMAKE([1.9 foreign -Wall -Werror subdir-objects])
+AM_PROG_AR
 #LT_INIT([win32-dll])
 AC_LIBTOOL_WIN32_DLL
