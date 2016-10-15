class Librdkafka < Formula
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/0.8.6.tar.gz"
  version "0.8.6"
  sha256 "184080e3898b80b3f7c1398c50787f8edb326b8271017a5f8000ef9a660e1a4f"

  depends_on "lzlib"
  
  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <librdkafka/rdkafka.h>
      int main (int argc, char **argv) {
      	int partition = RD_KAFKA_PARTITION_UA; /* random */
        return 0;
      }
    EOS
    system *%W[#{ENV.cxx} test.cpp -lrdkafka -lz -lpthread -o test]
    system "./test"
  end
end
