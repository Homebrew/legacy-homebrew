require 'formula'

class AvroC < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.4/c/avro-c-1.7.4.tar.gz'
  sha1 '1bd4c2fde2c9291bb50e05679f3e3e48c9c9eefa'

  # probably should be an optional dep
  conflicts_with 'xz'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
