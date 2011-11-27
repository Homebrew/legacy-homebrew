require 'formula'

class Cairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://www.cairographics.org/releases/cairo-1.10.2.tar.gz'
  sha1 'ccce5ae03f99c505db97c286a0c9a90a926d3c6e'

  depends_on 'pkg-config' => :build
  depends_on 'pixman'

  keg_only :provided_by_osx,
            "The Cairo provided by Leopard is too old for newer software to link against."

  fails_with_llvm "Gives an LLVM ERROR with Xcode 4 on some CPUs", :build => 2334

  def options
    [
      ["--universal", "Builds a universal binary"],
      ["--quartz", "Builds with Quartz rather than X."]
    ]
  end

  def install
    if ARGV.build_universal?
      ENV.universal_binary
      ENV.gcc_4_2 # This seems to be needed if you want a universal binary.
      ENV.append 'LDFLAGS', '-no-undefined -bind_at_load'
    end
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}",
            # enable useful features
            "--enable-ft", "--enable-pdf", "--enable-png", "--enable-ps",
            "--enable-script", "--enable-svg", "--enable-tee", "--enable-xml"]
    
    if ARGV.include? '--quartz'
      args << "--enable-quartz" << "--enable-quartz-font" << "--enable-quartz-image"
      args << "--disable-xlib"  << "--disable-xcb"        << "--without-x"
    else
      args << "--with-x"
    end
    system "./configure", *args
    
    system "make install"
  end
  
  def patches
    DATA if MacOS.lion?
  end
  
  def caveats
    "Cairo may need to be intalled with --quartz if you want any of its dependencies to have quartz."
  end
end

__END__
diff --git a/perf/cairo-perf-report.c perf/cairo-perf-report.c
index 8ab8090..a3d8bdb 100644
--- a/perf/cairo-perf-report.c
+++ perf/cairo-perf-report.c
@@ -49,7 +49,7 @@
 typedef ptrdiff_t ssize_t;
 #endif
 
-#if !defined (__USE_GNU) && !defined(__USE_XOPEN2K8)
+#if !defined (__USE_GNU) && !defined(__USE_XOPEN2K8) && MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_7
 static ssize_t
 getline (char	**lineptr,
 	 size_t  *n,
@@ -234,7 +234,7 @@ test_report_parse (test_report_t *report,
  * as needed. These aren't necessary full-fledged general purpose
  * implementations. They just get the job done for our purposes.
  */
-#if !defined (__USE_GNU) && !defined(__USE_XOPEN2K8)
+#if !defined (__USE_GNU) && !defined(__USE_XOPEN2K8) && MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_7
 #define POORMANS_GETLINE_BUFFER_SIZE (65536)
 static ssize_t
 getline (char	**lineptr,
diff --git a/perf/cairo-perf-trace.c b/perf/cairo-perf-trace.c
index ff22882..b3a4679 100644
--- a/perf/cairo-perf-trace.c
+++ perf/cairo-perf-trace.c
@@ -527,7 +527,7 @@ usage (const char *argv0)
 	     argv0, argv0);
 }
 
-#ifndef __USE_GNU
+#if !defined __USE_GNU  && MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_7
 #define POORMANS_GETLINE_BUFFER_SIZE (65536)
 static ssize_t
 getline (char	**lineptr,
diff --git a/src/cairo-quartz-font.c b/src/cairo-quartz-font.c
index f529fc9..1e57c39 100644
--- a/src/cairo-quartz-font.c
+++ src/cairo-quartz-font.c
@@ -802,7 +802,7 @@ _cairo_quartz_scaled_font_get_cg_font_ref (cairo_scaled_font_t *abstract_font)
     return ffont->cgFont;
 }
 
-#ifndef __LP64__
+#if !defined __LP64__ && MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_7
 /*
  * compat with old ATSUI backend
  */