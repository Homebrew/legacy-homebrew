class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/0.8.6.tar.gz"
  sha256 "184080e3898b80b3f7c1398c50787f8edb326b8271017a5f8000ef9a660e1a4f"

  bottle do
    cellar :any
    sha256 "355c27b5e831390916c4097701155dfd5b187a533b16e228ad22f7fcaa3d066a" => :yosemite
    sha256 "6de5dee723e8ef353e8230294688af6fa8a2dab4069015c7be837e5a14b26dc3" => :mavericks
    sha256 "b75648b576d5983858de5a1dd66a9f08e4f084c9290e93b5275c53796e8c9e0e" => :mountain_lion
  end

  depends_on "lzlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
