class Libb2 < Formula
  desc "Secure hashing function"
  homepage "https://blake2.net/"
  url "https://blake2.net/libb2-0.97.tar.gz"
  sha256 "7829c7309347650239c76af7f15d9391af2587b38f0a65c250104a2efef99051"

  bottle do
    cellar :any
    sha256 "4c604799e388530022494535a551c06bf08baba5d6d37fd5622f9fe50773b860" => :yosemite
    sha256 "513444d15673a2bba2b8042522db8fc68e25154955d18cb8eff6b8bb9bb4503f" => :mavericks
    sha256 "686a12f6cd03b3ed92c4f900f8a75a0467fd33c9b703678b06ad1060773b16b5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-fat",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"blake2test.c").write <<-EOS.undent
      #include <blake2.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
          uint8_t out[64];
          uint8_t expected[64] =
          {
            0xb2, 0x02, 0xb4, 0x77, 0xa7, 0x97, 0xe9, 0x84, 0xe6, 0xa2, 0xb9, 0x76,
            0xca, 0x4c, 0xb7, 0xd3, 0x94, 0x40, 0x04, 0xb3, 0xef, 0x6c, 0xde, 0x80,
            0x34, 0x1c, 0x78, 0x53, 0xa2, 0xdd, 0x7e, 0x2f, 0x9e, 0x08, 0xcd, 0xa6,
            0xd7, 0x37, 0x28, 0x12, 0xcf, 0x75, 0xe8, 0xc7, 0x74, 0x1f, 0xb6, 0x56,
            0xce, 0xc3, 0xa1, 0x19, 0x77, 0x2e, 0x2e, 0x71, 0x5c, 0xeb, 0xc7, 0x64,
            0x33, 0xfa, 0xfd, 0x4d
          };
          int res = blake2b(out, "blake2", "blake2", 64, 6, 6);
          if (res == 0) {
            if (memcmp(out, expected, 64) == 0) {
              return 0;
            } else {
              return 1;
            }
          } else {
            return 1;
          }
      }
    EOS
    system ENV.cc, "blake2test.c", "-lb2", "-o", "b2test"
    system "./b2test"
  end
end
