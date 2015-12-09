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
    sha256 "2ae7ce796b2f9318c7dd156c9014fcd214ab88d28e9af4b081161fc2166d732e" => :yosemite
    sha256 "6bd460eafc013874c19fc20734d82a43deba034da23df9bf8e54533b79740686" => :mavericks
    sha256 "64de9bbabe8ff8fd860d3db9d57eb55a83e5899f469731751f7da613a9155752" => :mountain_lion
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
