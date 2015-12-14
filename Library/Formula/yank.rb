class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.6.0.tar.gz"
  sha256 "06de92ab1368f29311264c7924457ec6ef0415f77c8d38e807b32bd89beb9cde"

  bottle do
    cellar :any_skip_relocation
    sha256 "108ab013dc85f6cea0dc45ec2753a6cb89d855354c6edcaaee4c4859b328a132" => :el_capitan
    sha256 "472e97039209d0490e517b4a16ca003c03eeca7ee819af3e0cf0feb4ba22a5a7" => :yosemite
    sha256 "e44007432eb1e51ccf430451d9f9123f0523b68ad2d84f1840c6f9b8646381d8" => :mavericks
  end

  # This is here to provide a temporary workaround for mptre/yank#22.
  # Once that is resolved in the next release, this can be removed.
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      #!/usr/bin/expect -f
      spawn sh
      set timeout 1
      send "echo key=value | yank -d = | cat"
      send "\r"
      send "\016"
      send "\r"
      expect {
            "value" { send "exit\r"; exit 0 }
            timeout { send "exit\r"; exit 1 }
      }
    EOS
    (testpath/"test").chmod 0755
    system "./test"
  end
end

__END__
diff --git a/yank.c b/yank.c
index fb971f5..fbc852c 100644
--- a/yank.c
+++ b/yank.c
@@ -26,8 +26,8 @@
 #define T_KEY_LEFT            "\033[D"
 #define T_KEY_RIGHT           "\033[C"
 #define T_KEY_UP              "\033[A"
-#define T_RESTORE_CURSOR      "\033[u"
-#define T_SAVE_CURSOR         "\033[s"
+#define T_RESTORE_CURSOR      "\0338"
+#define T_SAVE_CURSOR         "\0337"

 #define CONTROL(c) (c ^ 0x40)
 #define MIN(x, y) ((x) < (y) ? (x) : (y))
