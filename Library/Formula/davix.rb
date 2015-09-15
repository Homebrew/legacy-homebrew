class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
    :revision => "c53eb1472537da1694a5adc4c8fef5611eae7ab8",
    :tag => "R_0_5_0"
  version "0.5.0"

  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha1 "7b0e8b98a4bea320f53e18aee117b57b0e1e78d4" => :yosemite
    sha1 "c9f097cb09483cd1be6d18d76c04728d9dcb6622" => :mavericks
    sha1 "ed43d4321c579740ac29d3302f39f89e8c5f0ffb" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl"

  def install
    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "http://www.google.com"
  end
end
