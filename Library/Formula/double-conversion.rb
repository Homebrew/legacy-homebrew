class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/floitsch/double-conversion"
  url "https://github.com/floitsch/double-conversion/archive/v1.1.5.tar.gz"
  sha256 "03b976675171923a726d100f21a9b85c1c33e06578568fbc92b13be96147d932"

  head "https://github.com/floitsch/double-conversion.git"

  bottle do
    revision 1
    sha256 "a4bf917b0b18eadb4acd03721d59eb4ea355390f1de4ac1a5ff417827b93d7e1" => :yosemite
    sha256 "865ac5186cad14a25d49f26100197b8416b73784d67108d6c824d015d831e055" => :mavericks
    sha256 "9f4b00aa1763789c6df8c936a6c5a224ea48e6b76e0bbf6f68f1b73ffc9e6f68" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "dc-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <double-conversion/bignum.h>
      #include <stdio.h>
      int main() {
          char buf[20] = {0};
          double_conversion::Bignum bn;
          bn.AssignUInt64(0x1234567890abcdef);
          bn.ToHexString(buf, sizeof buf);
          printf("%s", buf);
          return 0;
      }
    EOS
    system ENV.cc, "test.cc", "-L#{lib}", "-ldouble-conversion", "-o", "test"
    assert_equal "1234567890ABCDEF", `./test`
  end
end
