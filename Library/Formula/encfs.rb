require 'formula'

class Encfs < Formula
  homepage 'https://vgough.github.io/encfs/'
  revision 1

  stable do
    url 'https://github.com/vgough/encfs/archive/v1.7.5.tar.gz'
    sha1 'f8bb2332b7a88f510cd9a18adb0f4fb903283edd'

    # Fix link times and xattr on links for OSX
    # Proper fix is already in upstream/dev
    patch :DATA
  end

  head 'https://github.com/vgough/encfs.git'

  bottle do
    sha1 "4e09e41ac19b52a14ea58644d6a3fcb61fdaea64" => :mavericks
    sha1 "ef7ea8cb89515be5e19b45a0af8704e65acbb150" => :mountain_lion
    sha1 "559bbec86eb4176fad7cb28368cc462f6470157f" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext' => :build
  depends_on 'boost'
  depends_on 'rlog'
  depends_on 'openssl'
  depends_on :osxfuse
  depends_on 'xz'

  def install
    # Fix linkage with gettext libs
    # Proper fix is already in upstream/master
    # Adapt to changes in recent Xcode by making local copy of endian-ness definitions
    mkdir "encfs/sys"
    cp "#{MacOS.sdk_path}/usr/include/sys/_endian.h", "encfs/sys/endian.h"

    if build.stable?
      inreplace "configure.ac", "LIBINTL=-lgettextlib", "LIBINTL=-lgettextlib -lintl"

      # Fix runtime "dyld: Symbol not found" errors
      # Following 3 ugly inreplaces are temporary solution
      # Proper fix is already in upstream
      inreplace ["encfs/Cipher.cpp", "encfs/CipherFileIO.cpp", "encfs/NullCipher.cpp",
                 "encfs/NullNameIO.cpp", "encfs/SSL_Cipher.cpp"], "using boost::shared_ptr;", ""

      inreplace ["encfs/BlockNameIO.cpp", "encfs/Cipher.cpp", "encfs/CipherFileIO.cpp",
                 "encfs/Context.cpp", "encfs/DirNode.cpp", "encfs/encfs.cpp",
                 "encfs/encfsctl.cpp", "encfs/FileNode.cpp", "encfs/FileUtils.cpp",
                 "encfs/MACFileIO.cpp", "encfs/main.cpp", "encfs/makeKey.cpp",
                 "encfs/NameIO.cpp", "encfs/NullCipher.cpp", "encfs/NullNameIO.cpp",
                 "encfs/SSL_Cipher.cpp", "encfs/StreamNameIO.cpp", "encfs/test.cpp"], "shared_ptr<", "boost::shared_ptr<"

      inreplace ["encfs/Context.cpp", "encfs/encfsctl.cpp", "encfs/FileUtils.cpp"], "boost::boost::shared_ptr<", "boost::shared_ptr<"
    end

    system "make", "-f", "Makefile.dist"
    # This provides a workaround for https://github.com/vgough/encfs/issues/18
    # osxfuse's installation directory cannot be given as a parameter to configure script
    inreplace "configure", "/usr/include/osxfuse /usr/local/include/osxfuse",
      "/usr/include/osxfuse /usr/local/include/osxfuse #{HOMEBREW_PREFIX}/include/osxfuse"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end

  test do
    if Pathname.new("/Library/Filesystems/osxfusefs.fs/Support/load_osxfusefs").exist?
      (testpath/"print-password").write("#!/bin/sh\necho password")
      chmod 0755, testpath/"print-password"
      system "yes | #{bin}/encfs --standard --extpass=#{testpath}/print-password #{testpath}/a #{testpath}/b"
      system "umount", testpath/"b"
    end
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
