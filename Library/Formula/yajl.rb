require 'formula'

class Yajl < Formula
  homepage 'http://lloyd.github.io/yajl/'
  url 'https://github.com/lloyd/yajl/archive/2.1.0.tar.gz'
  sha256 '3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a'

  bottle do
    cellar :any
    sha1 "418941bfd0684cf14ae0bebc65324e99b76a3aa4" => :mavericks
    sha1 "f59aa705d9324e1c4a47bbba7ba50b74b3649ca3" => :mountain_lion
    sha1 "1bea5088df669781cc1835a97ae991773ad7b36b" => :lion
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
