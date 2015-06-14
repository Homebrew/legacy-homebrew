class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
    :revision => "9d8f400ec1882602fc18312f35d617fe94ebbd67",
    :tag => "R_0_4_0-1"
  version "0.4.0-1"

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
