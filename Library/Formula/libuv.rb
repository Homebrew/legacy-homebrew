class Libuv < Formula
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.2.1.tar.gz"
  sha1 "500421538aaa84aa6ab054205275f59968556654"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha1 "1c63490d4bd7a38e83187d117a1782ad0c3ad884" => :yosemite
    sha1 "e3e0bd5e2351a0bd26e6975a8498c17e5f9d12bb" => :mavericks
    sha1 "715d7fd7d6f7a408093a66d7005b4816f2c63929" => :mountain_lion
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
