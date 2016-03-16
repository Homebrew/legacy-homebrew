class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.0/cpp/avro-cpp-1.8.0.tar.gz"
  sha256 "ec6e2ec957e95ca07f70cc25f02f5c416f47cb27bd987a6ec770dcbe72527368"

  bottle do
    cellar :any
    sha256 "42bb37f6038c5377ba5c1bee621a3b83dd71d64f11ff05c2eae6423431992ae0" => :el_capitan
    sha256 "d68908a760283fa48f536c470536ea639e5cf2a38bf51a5cea7e8c49065ca35a" => :yosemite
    sha256 "ebb608306b7337e4d05bb0826814b2f23d56e65854adaed92e8221c20c3c000d" => :mavericks
    sha256 "235ff24990def3b0850be9771a25cc74bc075ed2f943f4301a79da5053432b65" => :mountain_lion
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
