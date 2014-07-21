require "formula"

class Getdns < Formula
  homepage "http://getdnsapi.net"
  url "http://getdnsapi.net/dist/getdns-0.1.1.tar.gz"
  sha1 "63abbf10f514c6125c4bee0d249b9c68a9e4f560"

  bottle do
    revision 1
    sha1 "97d4143202cdcb3990f2eeac041c582db7d91a59" => :mavericks
    sha1 "73e1978b90fcd971d6e49c55d2ed0c0e4638fee6" => :mountain_lion
    sha1 "348ae9bb86398f484d2178104fc98b42963506eb" => :lion
  end

  depends_on "ldns"
  depends_on "unbound"
  depends_on "libidn"
  depends_on "libevent" => :optional
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    args = []
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
