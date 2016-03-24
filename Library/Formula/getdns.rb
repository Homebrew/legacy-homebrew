class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/dist/getdns-0.9.0.tar.gz"
  sha256 "b6b73a501ee79c0fafb0721023eb3a5d0e1bfa047fbe65302db278cb956bd1fe"

  head "https://github.com/getdnsapi/getdns.git"

  bottle do
    cellar :any
    sha256 "1ae532218ee2efd6c557a876d062a220ec4d604e24eca19160b394bea813a718" => :el_capitan
    sha256 "4e2eff05d371aedbd66bb428d8f01350134900ed4f4b647897d9c25b8492a45a" => :yosemite
    sha256 "18dcbddc502946fc6a146a52f255a4de75df80235b9b2dfcbaeee054fac355b2" => :mavericks
  end

  depends_on "openssl"
  depends_on "unbound"
  depends_on "libidn"
  depends_on "libevent" => :optional
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    args = [
      "--with-ssl=#{Formula["openssl"].opt_prefix}",
      "--with-trust-anchor=#{etc}/getdns-root.key",
    ]
    args << "--with-libevent" if build.with? "libevent"
    args << "--with-libev" if build.with? "libev"
    args << "--with-libuv" if build.with? "libuv"

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <getdns/getdns.h>

      int main(int argc, char *argv[]) {
        getdns_context *context;
        getdns_dict *api_info;
        char *pp;
        getdns_return_t r = getdns_context_create(&context, 0);
        if (r != GETDNS_RETURN_GOOD) {
            return -1;
        }
        api_info = getdns_context_get_api_information(context);
        if (!api_info) {
            return -1;
        }
        pp = getdns_pretty_print_dict(api_info);
        if (!pp) {
            return -1;
        }
        puts(pp);
        free(pp);
        getdns_dict_destroy(api_info);
        getdns_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-o", "test", "test.c", "-L#{lib}", "-lgetdns"
    system "./test"
  end
end
