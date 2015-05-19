class AvroC < Formula
  desc "Data serialization system"
  homepage "http://avro.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.7/c/avro-c-1.7.7.tar.gz"
  sha1 "cbb698682d662c5e0abec023dcd37ce1f3db80d4"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
