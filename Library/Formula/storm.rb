class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://github.com/apache/storm/archive/v0.9.5.tar.gz"
  sha256 "bff3fdd4ba04380b87777b5fa97fbc207fefe3653606a8e341d412415e9c9c8d"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/storm"
  end
end
