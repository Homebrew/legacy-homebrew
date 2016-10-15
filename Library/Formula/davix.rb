require "formula"

class Davix < Formula
  homepage "http://dmc.web.cern.ch/projects/davix/home"
  head "https://git.cern.ch/pub/davix.git"

  stable do
    url "https://git.cern.ch/pub/davix.git", :tag => "R_0_2_10-1"
    version "0.2.10-1"
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
