require 'formula'

class Libmowgli < Formula
  homepage 'http://www.atheme.org/project/mowgli'
  url 'https://github.com/atheme/libmowgli-2/archive/libmowgli-2.0.0.tar.gz'
  sha1 'dd3860fb116c4249456f13cd6c30c55e84388262'
  revision 1

  head 'https://github.com/atheme/libmowgli-2.git'

  bottle do
    cellar :any
    revision 1
    sha1 "2c93184500d004922cf66fb2b69615416ee06b29" => :mavericks
    sha1 "c903206aaef3215943d160bda3ac1c444066d846" => :mountain_lion
    sha1 "37d72d17a795cdda4cea876a9154557a0b35b4cf" => :lion
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
