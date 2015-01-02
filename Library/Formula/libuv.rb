class Libuv < Formula
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.1.0.tar.gz"
  sha1 "0c5d68bbfecd0bf2a6331403d375f791e34c298d"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha1 "46af35adc3ea259b3d9e0e3930df978d2b2f760b" => :yosemite
    sha1 "0ae353f8519f1d9da14397ce63e1f5711cc85403" => :mavericks
    sha1 "bde5f606395b8c46d1926b91a1b6fb971cfa9288" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <uv.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-luv", "-o", "test"
    system "./test"
  end
end
