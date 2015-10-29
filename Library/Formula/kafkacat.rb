class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat/archive/1.2.0.tar.gz"
  sha256 "43e5e3d6de7882324ca4afc3c1f6c49c8485d74b6e4eb4047ba5a6eba8c1cab9"

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
