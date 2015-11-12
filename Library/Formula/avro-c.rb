class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.7.7/c/avro-c-1.7.7.tar.gz"
  sha256 "69b56580f4cc63acbc49825153664ead44abdf1ff8f6f3511d5877533a745a66"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
