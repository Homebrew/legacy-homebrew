require "formula"

class Libical < Formula
  homepage "http://www.citadel.org/doku.php/documentation:featured_projects:libical"
  url "https://github.com/libical/libical/releases/download/v1.0.1/libical-1.0.1.tar.gz"
  sha1 "904b2c2b5c2b30f0a508f9d56eaf316dd42fc923"

  bottle do
    sha1 "c10d1810840c8f53ba3d8e2bbcb2256eeb1d0f5c" => :yosemite
    sha1 "01a42861a06728c22108fe6b2f8f7639aba12654" => :mavericks
    sha1 "bc6e1504443949302b95267702cd0f8314034d31" => :mountain_lion
  end

  depends_on "cmake" => :build

  option :universal

  def install
    args = std_cmake_args
    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    mkdir "build" do
      system "cmake", "..", "-DSHARED_ONLY=true", *args
      system "make", "install"
    end
  end
end
