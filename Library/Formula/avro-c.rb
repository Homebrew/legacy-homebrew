require 'formula'

class AvroC < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.6/c/avro-c-1.7.6.tar.gz'
  sha1 '890fb6e2fd5c12018e47b8fff49900a361a44a17'

  # probably should be an optional dep
  conflicts_with 'xz'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
