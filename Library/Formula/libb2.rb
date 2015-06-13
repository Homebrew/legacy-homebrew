class Libb2 < Formula
  desc "Secure hashing function"
  homepage "https://blake2.net/"
  url "https://blake2.net/libb2-0.96.tar.gz"
  sha256 "8cda63288637a9f8824bc036396e1fd78eb76c220ec020bfb441991508ba4f6f"

  bottle do
    cellar :any
    revision 2
    sha256 "0a905618380c1fa0cdecb54fb49f175a1a73b435bee0954921fabcf824f61801" => :yosemite
    sha256 "8186ac58f9312ee3f2599e06b894b8e1fdacb0f145d3ac43b436b3f248a97d6b" => :mavericks
    sha256 "5978374a05368c3812205a5ac8995af20bdc4c5e2040ffcfd49275cd2fc5a089" => :mountain_lion
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
