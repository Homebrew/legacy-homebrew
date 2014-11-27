require 'formula'

class Libmowgli < Formula
  homepage 'http://www.atheme.org/project/mowgli'
  url 'https://github.com/atheme/libmowgli-2/archive/libmowgli-2.0.0.tar.gz'
  sha1 'dd3860fb116c4249456f13cd6c30c55e84388262'
  revision 1

  head 'https://github.com/atheme/libmowgli-2.git'

  bottle do
    cellar :any
    revision 2
    sha1 "0a3085258a8765dc8e5fbc505073416c1d3c9bb3" => :yosemite
    sha1 "d282eac279ac76cdb01d355f919c45d41ed0c6c1" => :mavericks
    sha1 "a9502beb46258594b84b62aef2d970ec05d52456" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mowgli.h>

      int main(int argc, char *argv[]) {
        char buf[65535];
        mowgli_random_t *r = mowgli_random_create();
        mowgli_formatter_format(buf, 65535, "%1! %2 %3 %4.",\
                    "sdpb", "Hello World", mowgli_random_int(r),\
                    0xDEADBEEF, TRUE);
        puts(buf);
        mowgli_object_unref(r);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-lmowgli-2"
    system "./test"
  end
end
