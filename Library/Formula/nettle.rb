class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://www.lysator.liu.se/~nisse/archive/nettle-3.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-3.1.tar.gz"
  sha256 "f6859d4ec88e70805590af9862b4b8c43a2d1fc7991df0a7a711b1e7ca9fc9d3"

  bottle do
    cellar :any
    sha256 "c16f1f4ecbca92d491fbf215c8b6bafc4e7bfa3f632247dea04b40fd2bea0741" => :el_capitan
    sha256 "cbf6e6de707b1bf396cba2014f7ff73d079013cb877ecdc96f5ea29a3da66ec4" => :yosemite
    sha256 "9e93805f902033bb1c70bda4900c35b1a530409ac2743a810e21fdc14820e3a8" => :mavericks
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <nettle/sha1.h>
      #include <stdio.h>

      int main()
      {
        struct sha1_ctx ctx;
        uint8_t digest[SHA1_DIGEST_SIZE];
        unsigned i;

        sha1_init(&ctx);
        sha1_update(&ctx, 4, "test");
        sha1_digest(&ctx, SHA1_DIGEST_SIZE, digest);

        printf("SHA1(test)=");

        for (i = 0; i<SHA1_DIGEST_SIZE; i++)
          printf("%02x", digest[i]);

        printf("\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lnettle", "-o", "test"
    system "./test"
  end
end
