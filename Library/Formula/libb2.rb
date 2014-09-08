require "formula"

class Libb2 < Formula
  homepage "https://blake2.net"
  url "https://blake2.net/libb2-0.96.tar.gz"
  sha1 "e52ce4c788a972e3a49bbbe4380331030c4aca32"

  bottle do
    cellar :any
    sha1 "00e0573eec5ff0873c1ffabf934dd25b24ebdce7" => :mavericks
    sha1 "f3703fa2c3767b40335b3879975e0a56dbc509d1" => :mountain_lion
    sha1 "0ba183fbae79a9393649ba53472b345d4070eb14" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-fat",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'blake2test.c').write <<-EOS.undent
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
    system ENV["CC"], "blake2test.c", "-lb2", "-o", "b2test"
    system "./b2test"
  end
end
