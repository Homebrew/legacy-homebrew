class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://github.com/anholt/libepoxy/archive/v1.2.tar.gz"
  sha256 "42c328440f60a5795835c5ec4bdfc1329e75bba16b6e22b3a87ed17e9679e8f6"

  bottle do
    cellar :any
    sha1 "dabb8e5118bc90e09ecd908200dc2d3e7b4318a2" => :yosemite
    sha1 "0f3d1752a4a3b6783ea5a94327bfdb67428c5041" => :mavericks
    sha1 "d09e2a326f2bc061fae07f39c5a57421951bcda5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  resource "xorg-macros" do
    url "http://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.0.tar.bz2"
    sha256 "2835b11829ee634e19fa56517b4cfc52ef39acea0cd82e15f68096e27cbed0ba"
  end

  # This patch disables GLX on OSX, so that we don't have a runtime
  # dependency on x11.
  # It has been submitted at https://github.com/anholt/libepoxy/pull/28 and
  # will be included in the next release, according to libepoxy's author.
  patch :DATA

  def install
    resource("xorg-macros").stage do
      system "./configure", "--prefix=#{buildpath}/xorg-macros"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorg-macros/share/pkgconfig"
    ENV.append_path "ACLOCAL_PATH", "#{buildpath}/xorg-macros/share/aclocal"

    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent

      #include <epoxy/gl.h>
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      int main()
      {
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);

          glClear(GL_COLOR_BUFFER_BIT);
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lepoxy", "-framework", "OpenGL", "-o", "test"
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index f97c9b0..01842a4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,7 +65,7 @@ case $host_os in
         ;;
     darwin*)
         build_egl=no
-        build_glx=yes
+        build_glx=no
         build_wgl=no
         build_apple=yes
         has_znow=no
diff --git a/src/dispatch_common.h b/src/dispatch_common.h
index a4eb0f0..6b8503a 100644
--- a/src/dispatch_common.h
+++ b/src/dispatch_common.h
@@ -30,7 +30,7 @@
 #define EPOXY_IMPORTEXPORT __declspec(dllexport)
 #elif defined(__APPLE__)
 #define PLATFORM_HAS_EGL 0
-#define PLATFORM_HAS_GLX 1
+#define PLATFORM_HAS_GLX 0
 #define PLATFORM_HAS_WGL 0
 #define EPOXY_IMPORTEXPORT
 #elif defined(ANDROID)
