class Rapidjson < Formula
  homepage "https://miloyip.github.io/rapidjson/"
  url "https://github.com/miloyip/rapidjson/archive/v1.0.1.tar.gz"
  sha256 "a9003ad5c6384896ed4fd1f4a42af108e88e1b582261766df32d717ba744ee73"
  head "https://github.com/miloyip/rapidjson.git"

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
