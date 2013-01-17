require 'formula'

class AvroCpp < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.3/cpp/avro-cpp-1.7.3.tar.gz'
  sha1 'b8596a1d717f59d9d0e7d0130b36fa8b79a5be9f'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
