require "formula"

class Getdns < Formula
  homepage "http://getdnsapi.net"
  url "http://getdnsapi.net/dist/getdns-0.1.1.tar.gz"
  sha1 "63abbf10f514c6125c4bee0d249b9c68a9e4f560"

  bottle do
    sha1 "81336b0954cbe0eb533a4182abb21ec95c3ecd7e" => :mavericks
    sha1 "7504ab2cfe385bf7465ea521388e2ffb7762192f" => :mountain_lion
    sha1 "e8e24241af141b5ee10d8815c691b89f45986bd7" => :lion
  end

  depends_on "ldns"
  depends_on "unbound"
  depends_on "libidn"
  depends_on "libevent"
  depends_on "libuv" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
