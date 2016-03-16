class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.0/c/avro-c-1.8.0.tar.gz"
  sha256 "4fd93aa0b366e4f7c01a75065b10b9d34ea95ddcf81b7ca39287d6db4efe9bd4"

  bottle do
    cellar :any
    sha256 "6ec49623c99e6b02ea9b4cd020feb0bb362ef05aba4130fff5c2db4737415e7d" => :el_capitan
    sha256 "0bc09497b178b1e764345361cb183b3d788848b02c3d53a10d7dbc922c0e7bf1" => :yosemite
    sha256 "49411074ad6a551b5d5f9acff92a1263794a80aed7b6151a8c6ae768d66dc472" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "jansson" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
