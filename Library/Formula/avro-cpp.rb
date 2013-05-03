require 'formula'

class AvroCpp < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.4/cpp/avro-cpp-1.7.4.tar.gz'
  sha1 '1258c238692e4c7db97d62adead6efd9ef26ef71'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
