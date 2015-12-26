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
    revision 1
    sha256 "a30f6273f008e116f1d5a28300f87c09876f2e6a6d99ec066e0562adfd4605c6" => :el_capitan
    sha256 "ee3fb1d6b783a2ac5569b35bced1b6ff815d1357632268ebc4ae8b7f9261bc1f" => :yosemite
    sha256 "c8fc7c40b2dbbe177bb7ed819e2eaf5d165a1723d5dfcb4dcd351bce67e83b5f" => :mavericks
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
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
