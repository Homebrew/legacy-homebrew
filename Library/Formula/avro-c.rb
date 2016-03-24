class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.0/c/avro-c-1.8.0.tar.gz"
  sha256 "4fd93aa0b366e4f7c01a75065b10b9d34ea95ddcf81b7ca39287d6db4efe9bd4"

  bottle do
    cellar :any
    sha256 "6e2983b58e06fa1356fc64aabf818b002c6b8a093b3ede5bd13bda0314037949" => :el_capitan
    sha256 "9d43ac24878d7cfd3240c819f2a74e5c2b6edf0a1c2dbc205d18cc9bfae7092e" => :yosemite
    sha256 "d9fc74fd9baa1bd10f745f37d37c190ff3b3be48b77a30bef60af44a7e927f35" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "jansson" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
