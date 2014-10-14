require "formula"

class AvroCpp < Formula
  homepage "http://avro.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.7/cpp/avro-cpp-1.7.7.tar.gz"
  sha1 "2fdc16bfee5786053846341d89d11160df8d57d4"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
