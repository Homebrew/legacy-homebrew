class Vc4asm < Formula
  desc "Macro assembler for Broadcom VideoCore IV aka Raspberry Pi GPU"
  homepage "http://maazl.de/project/vc4asm/doc/index.html"
  url "https://github.com/maazl/vc4asm/archive/V0.1.8.tar.gz"
  sha256 "6e98d5263879c7e24762f707961fa3e31db9c43e6ffc2ef5b22d5d44a180d666"

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
