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
    sha256 "4bab71124c9638ab089f1784dd01805d814ee81e037fc6f8d7ddfd70a2ab785a" => :yosemite
    sha256 "8cdd2495b9286226b7be91e111a72f3d6d565b0245d5741f53901eb44266be3f" => :mavericks
    sha256 "00709d9ef997292d7154e92903c5375d5c9d572d6581814f1bd843b5319a76ab" => :mountain_lion
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
