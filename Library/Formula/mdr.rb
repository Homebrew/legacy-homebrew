class Mdr < Formula
  desc "Make diffs readable"
  homepage "https://github.com/halffullheart/mdr"
  url "https://github.com/halffullheart/mdr/archive/v1.0.1.tar.gz"
  sha256 "103d52c47133a43cc7a6cb8a21bfabe2d6e35e222d5b675bc0c868699a127c67"

  bottle do
    cellar :any
    sha256 "7048e71ef8f9a1d5c1712dce6cb33df08029038d771789021a1b8bc1e5f4ad10" => :yosemite
    sha256 "b80b64d56e7e77e9b53dd8c308dd50450552b782a72204cb710adf2de28c4f9e" => :mavericks
    sha256 "6280aee9902aabfcfdf6fb6ae094badc94ee1ad83d6caac4ca9b23f94803ec49" => :mountain_lion
  end

  def install
    system "rake"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"build/dev/mdr"
  end

  test do
    system "#{bin}/mdr", "-h"
  end
end
