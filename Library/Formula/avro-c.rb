require 'formula'

class AvroC < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.5/c/avro-c-1.7.5.tar.gz'
  sha1 '49859a3310073e579356690fed7d165aca33ec7d'

  # probably should be an optional dep
  conflicts_with 'xz'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
