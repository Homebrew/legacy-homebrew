class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://www.lysator.liu.se/~nisse/archive/nettle-3.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-3.2.tar.gz"
  sha256 "ea4283def236413edab5a4cf9cf32adf540c8df1b9b67641cfc2302fca849d97"

  bottle do
    cellar :any
    sha256 "149db1957c10656b05dd887d70ec699dc5e3776790fd2208a37b3a6fafa47f66" => :el_capitan
    sha256 "9d26a23ec1699a09d84dba677eba18944f9c7480e2061b36bb4c8ec2bca13a9e" => :yosemite
    sha256 "f86d2cf88360585545fb7309c8d631717801d90ecdfd9fdaf094aff32f4829f5" => :mavericks
  end

  depends_on "gmp"

  def install
    # OS X doesn't use .so libs. Emailed upstream 04/02/2016.
    inreplace "testsuite/dlopen-test.c", "libnettle.so", "libnettle.dylib"

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
