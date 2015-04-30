class AvroC < Formula
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.7/c/avro-c-1.7.7.tar.gz"
  sha1 "cbb698682d662c5e0abec023dcd37ce1f3db80d4"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
