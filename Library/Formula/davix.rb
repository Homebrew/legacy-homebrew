require "formula"

class Davix < Formula
  homepage "http://dmc.web.cern.ch/projects/davix/home"
  head "https://git.cern.ch/pub/davix.git"

  bottle do
    cellar :any
    sha1 "7fd2d4e6dd0d2572c9bf00df6e63e0f23349684e" => :mavericks
    sha1 "873460802e57043ba558741a0e04cb6b1ef61ec7" => :mountain_lion
    sha1 "b17e9338f9f545dcb2a6c336fd03cdf9bf6cbdcb" => :lion
  end

  stable do
    url "https://git.cern.ch/pub/davix.git", :tag => "R_0_3_1"
    version "0.3.1"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "http://www.google.com"
  end
end
