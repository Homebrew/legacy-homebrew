require 'formula'

class AvroC < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.6.3/c/avro-c-1.6.3.tar.gz'
  md5 'af3f15605b47d02719706e5d67de8e75'

  # probably should be an optional dep
  conflicts_with 'xz'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
