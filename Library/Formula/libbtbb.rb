require "formula"

class Libbtbb < Formula
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2014-02-R1.tar.gz"
  sha1 "d0004f7d7afdee949cd7ddf0e3f13510861a9c7d"
  version "2014-02-R1"

  head "https://github.com/greatscottgadgets/libbtbb.git"

  option :universal

  depends_on "cmake" => :build
  depends_on "python"

  def install
    if build.universal?
      ENV.universal_binary
      ENV["CMAKE_OSX_ARCHITECTURES"] = Hardware::CPU.universal_archs.as_cmake_arch_flags
    end
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
