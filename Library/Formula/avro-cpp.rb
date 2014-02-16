require 'formula'

class AvroCpp < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.6/cpp/avro-cpp-1.7.6.tar.gz'
  sha1 '6ef420797e14998d0889b1d6b34cd8d93480a332'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
