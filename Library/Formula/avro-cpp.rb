class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.0/cpp/avro-cpp-1.8.0.tar.gz"
  sha256 "ec6e2ec957e95ca07f70cc25f02f5c416f47cb27bd987a6ec770dcbe72527368"

  bottle do
    cellar :any
    sha256 "cb42e2b1ef02a5c0bca14e51e8b321c84da10b7e03be48ea0438f4207136e8fb" => :el_capitan
    sha256 "be2104270bfb75f688739a4ecf2d44d464818163c5b710f730b1b901fcc8b65a" => :yosemite
    sha256 "b1daac7b30febf55dc50261bb5a4d5cfd1928231b47968f2e2f620346579f94c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "boost"

  def install
    # Avoid deprecated macros removed in Boost 1.59.
    # https://issues.apache.org/jira/browse/AVRO-1719
    inreplace "test/SchemaTests.cc", "BOOST_CHECKPOINT(", "BOOST_TEST_CHECKPOINT("
    inreplace "test/buffertest.cc", "BOOST_MESSAGE(", "BOOST_TEST_MESSAGE("

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
