class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.1.2.tar.gz"
  sha256 "d8331bd0f7367c8afd5fcb5f5e85e96868a00fd24b7276fa5fcee1e5575c2662"

  bottle do
    cellar :any
    sha256 "869687ce2351144f53adb6a4606e6dc7ffc791cf6be9ec1cc229e29cb7754092" => :yosemite
    sha256 "621970cda40498627ae050ef66a8c43e94f6266014f9228424a4363b6d2d0fb8" => :mavericks
    sha256 "c252863cdb5da9ad87241f906a9d218a3e8c7136f8fff567ddf9922715c22389" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
