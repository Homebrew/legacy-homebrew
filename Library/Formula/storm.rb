class Storm < Formula
  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=storm/apache-storm-0.9.5/apache-storm-0.9.5.tar.gz"
  sha256 "2e8337126de8d1e180abe77fb81af7c971f8c4b2dad94e446ac86c0f02ba3fb2"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/storm"
  end
end
