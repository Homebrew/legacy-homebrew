class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat/archive/1.1.0.tar.gz"
  sha256 "290a16b6bbacedf2ae7b0eb89e1295ec803a378ecd7307485ebf4ef0a89702d9"

  bottle do
    cellar :any
    sha256 "88d376e81786a4be1cef64daafa233d6bcf9e664cbb1a6654e9b946842720e68" => :yosemite
    sha256 "a5a67429b038a546f3265cbb6660f9244e50e05ae26774f845d4b443b34b6b24" => :mavericks
    sha256 "06dbf479f58cf9b81e2ab1fbde95eacb6b9d088b25ab152a4900c139c28ab82b" => :mountain_lion
  end

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
