class Ccnet < Formula
  desc "A framework for writing networked applications in C"
  homepage "http://www.seafile.com/"
  url "https://github.com/haiwen/ccnet/archive/v4.2.8.tar.gz"
  sha256 "a5ae0b9f4ddd07bdb3702f69da94e9a3a1c28feaa18a8b9a792aae42cec413b2"

  head "https://github.com/haiwen/ccnet.git"

  # FIX for homebrew autotools path
  patch :DATA

  # FIX for openssl build
  patch :p1 do
    url "https://github.com/Chilledheart/ccnet/commit/4bede362.diff"
    sha1 "e6c540344dfa4d4650cf3e370f2421d897319ab6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "jansson"
  depends_on "libevent"
  depends_on "openssl"
  depends_on "libsearpc"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-client
      --disable-server
      --disable-compile-demo
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    mkdir_p testpath/"conf"
    (testpath/"conf/ccnet.conf").write <<-EOS.undent
      [General]
      USER_NAME = test
      ID = fa69e633a6bb4b08c27727d53db0450295258e52
      NAME = test@test.com

      [Network]
      PORT = 10001

      [Client]
      PORT = 13419
    EOS
    system "#{bin}/ccnet", "-c", testpath/"conf", "-d"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index cb0bbaa..df71a1c 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -63,7 +63,7 @@ aclocalinclude="$aclocalinclude -I m4"
 if test x"$MSYSTEM" = x"MINGW32"; then
     aclocalinclude="$aclocalinclude -I /local/share/aclocal"
 elif test "$(uname)" = "Darwin"; then
-    aclocalinclude="$aclocalinclude -I /opt/local/share/aclocal"
+    aclocalinclude="$aclocalinclude -I /usr/local/share/aclocal"
 fi
