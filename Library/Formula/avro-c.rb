require 'formula'

class AvroC < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.6.1/c/avro-c-1.6.1.tar.gz'
  homepage 'http://avro.apache.org/'
  md5 'd5c74692f9c4ff2f642b69fff56a6ae3'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
