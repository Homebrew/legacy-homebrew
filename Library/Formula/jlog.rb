class Jlog < Formula
  desc "Pure C simple durable message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.0.1.tar.gz"
  sha256 "ce4ec8495798e4f50af878f9fc3b922a46dd41df498a5602c802757df16499b7"

  bottle do
    cellar :any
    sha256 "72dcde70465b3483a9cca19b8ca6934a99176bfdb6582f89dd3d6b8009bf2f3b" => :yosemite
    sha256 "d0cd10cec8add751435cc2fda57d95b105df3ad2c5e58610051c125fdd52de47" => :mavericks
    sha256 "5bf4c685c14c48034909ac2f6a0346fc7992ae11e659e7f8b99964d7d41813c9" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"jlogtest.c").write <<-EOF.undent
      #include <stdio.h>
      #include <jlog.h>
      int main() {
        jlog_ctx *ctx;
        const char *path = "#{testpath}/jlogexample";
        int rv;

        // First, ensure that the jlog is created
        ctx = jlog_new(path);
        if (jlog_ctx_init(ctx) != 0) {
          if(jlog_ctx_err(ctx) != JLOG_ERR_CREATE_EXISTS) {
            fprintf(stderr, "jlog_ctx_init failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
            exit(1);
          }
          // Make sure it knows about our subscriber(s)
          jlog_ctx_add_subscriber(ctx, "one", JLOG_BEGIN);
          jlog_ctx_add_subscriber(ctx, "two", JLOG_BEGIN);
        }

        // Now re-open for writing
        jlog_ctx_close(ctx);
        ctx = jlog_new(path);
        if (jlog_ctx_open_writer(ctx) != 0) {
           fprintf(stderr, "jlog_ctx_open_writer failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
           exit(0);
        }

        // Send in some data
        rv = jlog_ctx_write(ctx, "hello\\n", strlen("hello\\n"));
        if (rv != 0) {
          fprintf(stderr, "jlog_ctx_write_message failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
        }
        jlog_ctx_close(ctx);
      }
    EOF
    system ENV.cc, "jlogtest.c", "-I#{include}", "-ljlog", "-o", "jlogtest"
    system testpath/"jlogtest"
  end
end
