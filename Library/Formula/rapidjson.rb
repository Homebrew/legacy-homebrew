class Rapidjson < Formula
  homepage "https://miloyip.github.io/rapidjson/"
  url "https://github.com/miloyip/rapidjson/archive/v1.0.1.tar.gz"
  sha256 "a9003ad5c6384896ed4fd1f4a42af108e88e1b582261766df32d717ba744ee73"
  head "https://github.com/miloyip/rapidjson.git"

  bottle do
    sha256 "2b92e5e53744612527ecf715da9bf5de106a099c67fb1ec2d8265e411011357c" => :yosemite
    sha256 "c2b36ff73da8dc865805693a4ac023e31a244bd643676ff2bd8b0866d3d01b51" => :mavericks
    sha256 "2eec4643f5e673622623e7b0fa8d8409667ec794c6e9ae5b2aa9c773758fa201" => :mountain_lion
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
