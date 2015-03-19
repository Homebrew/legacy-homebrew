class DoubleConversion < Formula
  homepage "https://github.com/floitsch/double-conversion"
  url "https://github.com/floitsch/double-conversion/archive/v1.1.5.tar.gz"
  sha256 "03b976675171923a726d100f21a9b85c1c33e06578568fbc92b13be96147d932"

  head "https://github.com/floitsch/double-conversion.git"

  bottle do
    sha256 "fcc66e2f108a02bfc77b72f457d40558eb8aa3d79559c41cfb799d5add66798b" => :yosemite
    sha256 "f6f0c47ce0c6acbec8818d47f387bcc1063ef07ce39692a735b68af5f9c7d5cf" => :mavericks
    sha256 "cda6b3e1c4bfcd6d7de56478f4fba9b3e2b908fe399ff9d7e66f9a8ecc73e684" => :mountain_lion
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
