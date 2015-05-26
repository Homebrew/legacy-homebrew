class Mlogger < Formula
  homepage "https://github.com/nbrownus/mlogger"
  url "https://github.com/nbrownus/mlogger/archive/v1.1.2.tar.gz"
  sha256 "4163687c80b618f3e6c307eeba86cb95097661375cf76c977e8aad1bbc48ee99"

  def install
    system "make"
    bin.install "mlogger"
  end

  test do
    system "mlogger", "-i", "-d", "test"
  end
end
