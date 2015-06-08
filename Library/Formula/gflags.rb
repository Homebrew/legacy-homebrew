class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.1.2.tar.gz"
  sha256 "d8331bd0f7367c8afd5fcb5f5e85e96868a00fd24b7276fa5fcee1e5575c2662"

  bottle do
    cellar :any
    revision 1
    sha256 "8bbbd5efff7f825bfad987b7fc2f55f41c81e23ee0758645a079e6fbe9369fd7" => :yosemite
    sha256 "52bd446dc3ba39b7e8a821e2f483cb5be8ad6f24b487cf9296ebc5b94a143b24" => :mavericks
    sha256 "9dfeb3e15cf5d5082ad017e7390b7919fe94707291f1edbd77158805a63ad0e9" => :mountain_lion
  end

  option "with-debug", "Build debug version"

  depends_on "cmake" => :build

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
