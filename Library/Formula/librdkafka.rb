class Librdkafka < Formula
  homepage "https://github.com/edenhill/librdkafka"
  url "http://github.com/edenhill/librdkafka/archive/0.8.6.tar.gz"
  sha256 "184080e3898b80b3f7c1398c50787f8edb326b8271017a5f8000ef9a660e1a4f"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
