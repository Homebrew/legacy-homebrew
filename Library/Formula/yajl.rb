require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.io/yajl/'
  url 'https://github.com/lloyd/yajl/archive/2.1.0.tar.gz'
  sha256 '3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a'

  bottle do
    cellar :any
    revision 3
    sha1 "3365b3fd3e47023adf9aacdff66dd5570bddb124" => :yosemite
    sha1 "ba8a07a67cc0c8b4f6ea92f7dc7ef3008fdf222f" => :mavericks
    sha1 "1017b9a117f55464eac2eb254e0d8aa9e181b5c9" => :mountain_lion
  end

  # Configure uses cmake internally
  depends_on 'cmake' => :build

  def install
    ENV.deparallelize

    system "cmake", ".", *std_cmake_args
    system "make install"
    (include/'yajl').install Dir['src/api/*.h']
  end

  test do
    output = pipe_output("#{bin}/json_verify", "[0,1,2,3]").strip
    assert_equal "JSON is valid", output
  end
end
