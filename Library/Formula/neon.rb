class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "http://www.webdav.org/neon/"
  url "http://www.webdav.org/neon/neon-0.30.1.tar.gz"
  sha256 "00c626c0dc18d094ab374dbd9a354915bfe4776433289386ed489c2ec0845cdd"

  bottle do
    cellar :any
    sha256 "b971936d607e7bbc701218a731af78fa7582efa23372740a71254639fc97ed9e" => :el_capitan
    sha256 "08693500c96c18dbf0def5fe5a56dc22fbad1166116eceae5ea460b735a24bf3" => :yosemite
    sha256 "32799a0de60650c9d1aa19b68c9d972b0f596dcfd2c979634fc35c8e98665ed3" => :mavericks
    sha256 "fdbf3525a1b9a7b4797f6770bbc6e77c89118e55253d9e33f2f48cb09a06ff0f" => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build
  depends_on "openssl"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    ENV.enable_warnings
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index d7702d2..5c3b5a3 100755
--- a/configure
+++ b/configure
@@ -4224,7 +4224,6 @@ fi
 $as_echo "$ne_cv_os_uname" >&6; }
 
 if test "$ne_cv_os_uname" = "Darwin"; then
-  CPPFLAGS="$CPPFLAGS -no-cpp-precomp"
   LDFLAGS="$LDFLAGS -flat_namespace"
   # poll has various issues in various Darwin releases
   if test x${ac_cv_func_poll+set} != xset; then
