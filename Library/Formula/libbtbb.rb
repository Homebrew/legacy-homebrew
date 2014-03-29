require "formula"

class Libbtbb < Formula
  homepage "https://github.com/greatscottgadgets/libbtbb"
  url "https://github.com/greatscottgadgets/libbtbb/archive/2014-02-R2.tar.gz"
  sha1 "aa94b7d92465704aa647123f11e906491a26d090"
  version "2014-02-R2"

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
