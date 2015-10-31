class W3m < Formula
  desc "Pager/text based browser"
  homepage "http://w3m.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.3/w3m-0.5.3.tar.gz"
  sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

  bottle do
    sha256 "c6443287699a058e58ff0e378a8f6459370de79f89246ac7217e11f9f748abed" => :el_capitan
    sha256 "57a644921789316e92cbc37d2e0c51eaf5591876992626a9bcf9f4a56c0e3897" => :yosemite
    sha256 "e2972a26e7c734e6814257516ebda796e907df5787906c4144321fc63e70f1a1" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl"

  fails_with :llvm do
    build 2334
  end

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-image",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    # Race condition in build reported in:
    # https://github.com/Homebrew/homebrew/issues/12854
    ENV.j1
    system "make", "install"
  end

  test do
    assert_match /DuckDuckGo/, shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end

__END__
diff --git a/main.c b/main.c
index b421943..865c744 100644
--- a/main.c
+++ b/main.c
@@ -833,7 +833,12 @@ main(int argc, char **argv, char **envp)
     mySignal(SIGPIPE, SigPipe);
 #endif
 
+#if GC_VERSION_MAJOR >= 7 && GC_VERSION_MINOR >= 2
+    orig_GC_warn_proc = GC_get_warn_proc();
+    GC_set_warn_proc(wrap_GC_warn_proc);
+#else
     orig_GC_warn_proc = GC_set_warn_proc(wrap_GC_warn_proc);
+#endif
     err_msg = Strnew();
     if (load_argc == 0) {
 	/* no URL specified */
