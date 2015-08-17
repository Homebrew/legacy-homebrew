class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/dist/getdns-0.3.1.tar.gz"
  sha256 "58fd791187d5fd158ba7db1b5f29d4b0274583447f405577c758c7c7751e8883"

  head "https://github.com/getdnsapi/getdns.git"

  bottle do
    cellar :any
    sha256 "66be49d1fe111e14d181aa1054041fa14b87a5cddabb0333bbb6cdc29e4c580f" => :yosemite
    sha256 "5910d400f5e2f83b49ccc01379691e7a2b2300af815bc517d079811f7968fcf9" => :mavericks
    sha256 "b3eb2d9b1db54455204c1bdb0e40ea5b44cc1fe9b4ef6de13085e9553c1f0366" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "ldns"
  depends_on "unbound"
  depends_on "libidn"
  depends_on "libevent" => :optional
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    args = [
      "--with-ssl=#{Formula["openssl"].opt_prefix}",
      "--with-trust-anchor=#{etc}/getdns-root.key"
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
    system ENV.cc, "-I#{include}", "-o", "test", "test.c", "-lgetdns"
    system "./test"
  end
end
