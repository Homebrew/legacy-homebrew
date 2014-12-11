require "formula"

class Davix < Formula
  homepage "http://dmc.web.cern.ch/projects/davix/home"
  url "https://git.cern.ch/pub/davix.git", :tag => "R_0_4_0-1"
  version "0.4.0-1"

  head "https://git.cern.ch/pub/davix.git"

  bottle do
    cellar :any
    sha1 "5cfd3f49de7034c40ec309a5a17514caf46e9e8e" => :yosemite
    sha1 "525f241213630dfeaa3ec9d5ea019c8a0670b4dc" => :mavericks
    sha1 "21befa078d3cdea7369e037999a9e5be24f3157d" => :mountain_lion
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
