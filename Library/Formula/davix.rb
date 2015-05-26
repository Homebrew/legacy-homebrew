require "formula"

class Davix < Formula
  homepage "http://dmc.web.cern.ch/projects/davix/home"
  url "https://git.cern.ch/pub/davix.git", :tag => "R_0_4_0-1"
  version "0.4.0-1"

  head "https://git.cern.ch/pub/davix.git"

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
