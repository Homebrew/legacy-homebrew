class Kafkacat < Formula
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat/archive/1.1.0.tar.gz"
  sha256 "290a16b6bbacedf2ae7b0eb89e1295ec803a378ecd7307485ebf4ef0a89702d9"

  depends_on "librdkafka"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end
