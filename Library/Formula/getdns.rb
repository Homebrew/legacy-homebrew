require "formula"

class Getdns < Formula
  homepage "http://getdnsapi.net"
  url "http://getdnsapi.net/dist/getdns-0.1.4.tar.gz"
  sha1 "9833f96cf23c845008405cec411c1f2005e40dc3"

  bottle do
    sha1 "efad47ff71c7205beb6ab03c133853909031c538" => :mavericks
    sha1 "860489f9eab66b247e32e8a960e0960a1d0109f0" => :mountain_lion
    sha1 "7bdfa25a8aa1c9729dda8cfb1f106aea1a9e1aba" => :lion
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
