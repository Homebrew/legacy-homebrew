class Gflags < Formula
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.1.2.tar.gz"
  sha256 "d8331bd0f7367c8afd5fcb5f5e85e96868a00fd24b7276fa5fcee1e5575c2662"

  depends_on "cmake" => :build

  def install
    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
