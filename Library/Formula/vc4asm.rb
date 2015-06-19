class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.1.7.tar.gz"
  sha256 "db9c50c1cc035a183ce8305a82a01cad08a246d13c718c420a8762296b00e3de"

  bottle do
    cellar :any
    sha256 "2d7c7eaad829267e1fcfba73ee1e31ee17c1a6e86c3be8d6fcab9acf5b311617" => :yosemite
    sha256 "ad9c0bb8312909a8a601edd37e63ba49a115a85b306e4d7c648142815f70121d" => :mavericks
    sha256 "763bdc099d24ddb7fe000e675e1a3405544a41e48e92701d06b7199d4bfb4df5" => :mountain_lion
  end

  depends_on "cmake" => :build

  needs :cxx11

  patch do
    url "https://github.com/maazl/vc4asm/pull/2.patch"
    sha256 "9b7996563a6b15ae7d5578df6d08b43413dc1758e8e2002115ba414daed323e3"
  end

  def install
    ENV.cxx11
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.qasm").write <<-EOS.undent
      mov -, sacq(9)
      add r0, r4, ra1.unpack8b
      add.unpack8a r0, r4, ra1
      add r0, r4.8a, ra1
    EOS
    system "#{bin}/vc4asm", "-o test.hex", "-V", "#{share}/vc4.qinc", "test.qasm"
  end
end
