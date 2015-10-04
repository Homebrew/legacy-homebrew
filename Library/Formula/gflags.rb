class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.1.2.tar.gz"
  sha256 "d8331bd0f7367c8afd5fcb5f5e85e96868a00fd24b7276fa5fcee1e5575c2662"

  bottle do
    cellar :any
    revision 2
    sha256 "6ed095ce8dc4921841a7dd0045f9160d6704dba6853dd631ee6855a02efb6bde" => :el_capitan
    sha256 "8e648b5824007745eb546beffe4d94a3c25a29556f89eaa4a156dec6984335dd" => :yosemite
    sha256 "8f4093596ce2b359821d9a3398b82d7d327288d24ca9f0218a9ade1ace2bdbfa" => :mavericks
    sha256 "19d46507297d14c4ff50d99c9279ddd513df439a5d87e5325ef8fb52c37f7e6d" => :mountain_lion
  end

  option "with-debug", "Build debug version"
  option "with-static", "Build gflags as a static (instead of shared) library."

  depends_on "cmake" => :build

  def install
    ENV.append_to_cflags "-DNDEBUG" if build.without? "debug"
    args = std_cmake_args
    if build.with? "static"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end
    mkdir "buildroot" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
