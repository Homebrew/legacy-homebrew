require "formula"

class Libical < Formula
  homepage "http://www.citadel.org/doku.php/documentation:featured_projects:libical"
  url "https://github.com/libical/libical/releases/download/v1.0.1/libical-1.0.1.tar.gz"
  sha1 "904b2c2b5c2b30f0a508f9d56eaf316dd42fc923"

  bottle do
    revision 1
    sha1 "18d0e60043b3b78eb6872f53a0508537d7fcd5db" => :yosemite
    sha1 "cea6dad5171431e1f7a5d7e12beb7c6eb4c3951c" => :mavericks
    sha1 "e19ed113cb312dfeea12fba84f21f29f5866db99" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DSHARED_ONLY=true", *std_cmake_args
      system "make", "install"
    end
  end
end
