class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.8.8.tar.gz"
  sha256 "08f4a85ef419a8bdf08b6afa8f7b2a0e5e180fdc9c16cede81af672ec10e21e7"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "a67aa03ee2d0643b652be84252e5d33f62d7a315ff2d581dcbbb1c938c7ca9a3" => :el_capitan
    sha256 "73c638c2bf7572e9ff6a87b8cbe99349c25544606aba13706f6719b3cbe66d07" => :yosemite
    sha256 "1e874fe49c1b35f613ba86d28b53783bdf2c55d67cdd838e23d86f278657dd42" => :mavericks
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
    (testpath/"test.c").write <<-EOS.undent
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
