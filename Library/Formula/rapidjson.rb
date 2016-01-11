class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://miloyip.github.io/rapidjson/"
  url "https://github.com/miloyip/rapidjson/archive/v1.0.2.tar.gz"
  sha256 "c3711ed2b3c76a5565ee9f0128bb4ec6753dbcc23450b713842df8f236d08666"
  head "https://github.com/miloyip/rapidjson.git"

  bottle do
    sha256 "32067dca55523d203d836e416fd80e2a70d5f0907725e5eb6a6c4c988fee3d3d" => :yosemite
    sha256 "7686ef10f5702518ff4feff0c5b609c8c21e6796bf2c8cc37f48594a1486f188" => :mavericks
    sha256 "e31ed3128e73c9450e54c6139b3e0211edc0857bee27829029058b690aa7d747" => :mountain_lion
  end

  option "without-docs", "Don't build documentation"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build if build.with? "docs"

  def install
    args = std_cmake_args
    args << "-DRAPIDJSON_BUILD_DOC=OFF" if build.without? "docs"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}',  pipe_output("./capitalize", '{"a":"b"}')
  end
end
