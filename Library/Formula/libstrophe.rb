class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.8.6.tar.gz"
  sha256 "a2158134381e544a7697e9379f45abe18da817cd05eb3272eabec2151599d702"
  head "https://github.com/strophe/libstrophe.git"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "b533ba5fbc93054ff666907002045eb057decaa582223610135bf5240f2f579b" => :el_capitan
    sha1 "cba04617714a99e25d71ab0efd9d26d046d336c4" => :yosemite
    sha1 "1f824c9bcb4d8e370e5423d26b75bc926de23afc" => :mavericks
    sha1 "5ed9df92858ba19d256cfc99c1459649b4840f68" => :mountain_lion
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
