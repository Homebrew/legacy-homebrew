class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-0.9.4/apache-storm-0.9.4.tar.gz"
  sha256 "2cdb3530839375bb5f18751ff16ff78b11e9b4f6d23c423c95d78487ad92d38e"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/storm"
  end
end
