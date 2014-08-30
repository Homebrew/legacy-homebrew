require "formula"

class Davix < Formula
  homepage "http://dmc.web.cern.ch/projects/davix/home"
  url "https://git.cern.ch/pub/davix.git", :tag => "R_0_3_4"
  version "0.3.4"

  head "https://git.cern.ch/pub/davix.git"

  bottle do
    cellar :any
    sha1 "26b49cc9cc80dfcd4afe3e7cc2ee2621a18e1270" => :mavericks
    sha1 "ecbe105f2e286df23107daf69aa2e1d2ad58b5dd" => :mountain_lion
    sha1 "3b374d8e9dd79c8dbe59d94d8226ef93778e5325" => :lion
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
