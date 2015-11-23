class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/dist/getdns-0.5.0.tar.gz"
  sha256 "b0680170249ba9987b8af4c7f2bc64833fe6396ecd66565c991b33775f78ccdb"

  head "https://github.com/getdnsapi/getdns.git"

  bottle do
    cellar :any
    sha256 "3cd3d254095f1e763cceb1ee1aa143392f545e6db695e2f42e01e4d6d03f3603" => :el_capitan
    sha256 "944dfc0254806c44beb2f731caa5a670b273c8363c2cfe19db17ca895afbf333" => :yosemite
    sha256 "aef42eabcbcfcbcf9c7d416c9d607da580e6447a08b61088d6bd5a9ffc7c9fbe" => :mavericks
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
