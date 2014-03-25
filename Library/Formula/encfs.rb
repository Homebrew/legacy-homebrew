require 'formula'

class Encfs < Formula
  homepage 'http://www.arg0.net/encfs'
  url 'https://encfs.googlecode.com/files/encfs-1.7.4.tgz'
  sha1 '3d824ba188dbaabdc9e36621afb72c651e6e2945'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'rlog'
  depends_on 'osxfuse'

  # Following patch and changes in install section,
  # required for better compatibility with OSX, especially OSX 10.9.
  # Changes are already in usptream and planned to be included in next stable release 1.75.
  # For more details refer to:
  # https://code.google.com/p/encfs/issues/detail?id=185#c10
  # Fixes link times and xattr on links for OSX
  patch :DATA

  def install
    # Add correct flags for linkage with {osx,}fuse and gettext libs
    gettext = Formula['gettext']
    ENV.append 'CPPFLAGS', %x[pkg-config fuse --cflags].chomp + "-I#{gettext.include}"
    ENV.append 'LDFLAGS', %x[pkg-config fuse --libs].chomp + "-L#{gettext.lib}"
    inreplace "configure", "-lfuse", "-losxfuse"

    # Adapt to changes in recent Xcode by making local copy of endian-ness definitions
    system "mkdir encfs/sys"
    system "cp \"$HOMEBREW_SDKROOT/usr/include/sys/_endian.h\" encfs/sys/endian.h"

    # Fix runtime "dyld: Symbol not found" errors
    # Following 3 ugly inreplaces come instead of big patch
    inreplace ["encfs/Cipher.cpp", "encfs/CipherFileIO.cpp", "encfs/NullCipher.cpp",
               "encfs/NullNameIO.cpp", "encfs/SSL_Cipher.cpp"], "using boost::shared_ptr;", ""

    inreplace ["encfs/BlockNameIO.cpp", "encfs/Cipher.cpp", "encfs/CipherFileIO.cpp",
               "encfs/Context.cpp", "encfs/DirNode.cpp", "encfs/encfs.cpp",
               "encfs/encfsctl.cpp", "encfs/FileNode.cpp", "encfs/FileUtils.cpp",
               "encfs/MACFileIO.cpp", "encfs/main.cpp", "encfs/makeKey.cpp",
               "encfs/NameIO.cpp", "encfs/NullCipher.cpp", "encfs/NullNameIO.cpp",
               "encfs/SSL_Cipher.cpp", "encfs/StreamNameIO.cpp", "encfs/test.cpp"], "shared_ptr<", "boost::shared_ptr<"

    inreplace ["encfs/Context.cpp", "encfs/encfsctl.cpp", "encfs/FileUtils.cpp"], "boost::boost::shared_ptr<", "boost::shared_ptr<"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end
end

__END__

--- a/encfs/encfs.cpp
+++ b/encfs/encfs.cpp
@@ -489,7 +489,11 @@
 
 int _do_chmod(EncFS_Context *, const string &cipherPath, mode_t mode)
 {
+#ifdef __APPLE__
+    return lchmod( cipherPath.c_str(), mode );
+#else
     return chmod( cipherPath.c_str(), mode );
+#endif
 }
 
 int encfs_chmod(const char *path, mode_t mode)
@@ -706,7 +710,11 @@
 int _do_setxattr(EncFS_Context *, const string &cyName, 
 	tuple<const char *, const char *, size_t, uint32_t> data)
 {
+#ifdef __APPLE__
+    int options = XATTR_NOFOLLOW;
+#else
     int options = 0;
+#endif
     return ::setxattr( cyName.c_str(), data.get<0>(), data.get<1>(), 
 	    data.get<2>(), data.get<3>(), options );
 }
