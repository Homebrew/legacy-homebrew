class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.0.1.tar.gz"
  sha256 "ae6619baa3da78361b09d22c155b1406b17890009d93ed60445381eb03016b76"

  bottle do
    cellar :any_skip_relocation
    sha256 "d762cad1a4a5674a1543d72f790e94c378d37d9047c39a57fa213b22902d944f" => :el_capitan
    sha256 "c38715d9ce35dc64e6b66c50b86b57b283cde26fa4719dfa8868ed4b7097cf49" => :yosemite
    sha256 "c7bfbbec66aacc4a8a79af7c6edb45cd09873d7e6ed8fc39cca0b15a6b1805cc" => :mavericks
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "boost" => :build
  depends_on "ragel" => :build
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
