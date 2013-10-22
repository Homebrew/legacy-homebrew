require 'formula'

class AvroCpp < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.5/cpp/avro-cpp-1.7.5.tar.gz'
  sha1 '8017abbbeb25e092afbffda5acf70df639662190'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
