class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.7/cpp/avro-cpp-1.7.7.tar.gz"
  sha256 "f9bdfad58f513014940fcda372840e36f4f3787a20a00bc0666d254973a1ec1d"

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
