class Kafkalite < Formula
  desc "A light weight embeddable version of Kafka"
  homepage "https://github.com/panyam/KafkaLite/"
  url "https://github.com/panyam/KafkaLite/releases/download/V0.0.4/libkafkalite-0.0.4.tar.gz"
  sha256 "1b7ea59014065ea457c776426ed842c67c8a596ffcfe60f0097e892b4c41122f"

  depends_on "cppunit"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
