require "formula"

class Libstrophe < Formula
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.8.6.tar.gz"
  sha1 "fc30c78945cb075a636cff8c76be671c8a364eb0"
  head "https://github.com/strophe/libstrophe.git"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "ec45dcfd06cd95348d5442155ed4ef71f34bd20d" => :mavericks
    sha1 "d6b2842f061190b981354f4e98d61fa20bd2c18c" => :mountain_lion
    sha1 "337e6f19415f2b50ba3ed1ad3025cd9b319087ff" => :lion
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
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
