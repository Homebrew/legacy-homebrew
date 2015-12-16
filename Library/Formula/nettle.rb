class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://www.lysator.liu.se/~nisse/archive/nettle-3.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-3.1.tar.gz"
  sha256 "f6859d4ec88e70805590af9862b4b8c43a2d1fc7991df0a7a711b1e7ca9fc9d3"

  bottle do
    cellar :any
    revision 1
    sha256 "c4d9262d13cae53467788b50eeebdc39b9adbba0367070b1d21d059c99159590" => :el_capitan
    sha256 "7f006b8cf57112837ad7b4e9a82e30a4007c161eb32e552e16bcb6c47e8a3a1d" => :yosemite
    sha256 "9adfe3d199966936d8d8977769fddb2cb71334e64b18f2ec081a155de6308c16" => :mavericks
    sha256 "26082a9e2cab89927a3593ca7af7624de81720c4b7faab9dbf83baa838105851" => :mountain_lion
    sha256 "6a46aec5ff57bffdc658d1c375b48cfbe162eceeb52f1865c98e85a5fd23de50" => :lion
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
