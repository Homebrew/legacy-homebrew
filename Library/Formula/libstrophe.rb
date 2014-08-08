require "formula"

class Libstrophe < Formula
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.8.5.tar.gz"
  sha1 "11f80abb8e578c5bc446ff94603e7e0f560547f7"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha1 "541e0c27a82f39b71eb95bb17169b36f9ffed8c0" => :mavericks
    sha1 "73e49037a4553f90d846a73c6aad1301921f4848" => :mountain_lion
    sha1 "a74416c594d17598e4acaea5aea74247c57900bd" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "check"

  def install
    # see https://github.com/strophe/libstrophe/issues/28
    ENV.deparallelize

    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include <strophe.h>
      #include <assert.h>

      int main(void) {
        xmpp_ctx_t *ctx;
        xmpp_log_t *log;

        xmpp_initialize();
        log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG);
        assert(log);

        ctx = xmpp_ctx_new(NULL, log);
        assert(ctx);

        xmpp_ctx_free(ctx);
        xmpp_shutdown();
        return 0;
      }
      EOS
    flags = ["-I#{include}/", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.split)
    system "./test"
  end
end
