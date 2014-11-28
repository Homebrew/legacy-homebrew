require "formula"

class Qca < Formula
  homepage "http://delta.affinix.com/qca/"
  url "http://delta.affinix.com/download/qca/2.0/qca-2.1.0.tar.gz"
  sha1 "2b582b3ccc7e6098cd14d6f52a829ae1539e9cc8"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/qcatool", "--noprompt", "--newpass=",
                             "key", "make", "rsa", "2048", "test.key"
  end
end
