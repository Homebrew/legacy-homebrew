require "formula"

class Getdns < Formula
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/dist/getdns-0.2.0.tar.gz"
  sha1 "6843984f7ed8109302bda3b37f5247fd49827f90"

  head "https://github.com/getdnsapi/getdns.git"

  bottle do
    sha1 "86879ca8d95414125287abc89393781bcd801f88" => :yosemite
    sha1 "c826c175dc647cf68bd8ba12dcc9c78da232fb87" => :mavericks
    sha1 "1c393a248ef0633265f1e40c335a6ddf1fd7794e" => :mountain_lion
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
