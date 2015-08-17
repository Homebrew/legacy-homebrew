class Mdr < Formula
  desc "Make diffs readable"
  homepage "https://github.com/halffullheart/mdr"
  url "https://github.com/halffullheart/mdr/archive/v1.0.1.tar.gz"
  sha256 "103d52c47133a43cc7a6cb8a21bfabe2d6e35e222d5b675bc0c868699a127c67"

  bottle do
    cellar :any
    sha1 "d1a11e01a31b003c5f6ccb817af9299d176465f3" => :yosemite
    sha1 "55ccdc1bff014dcea22853c8a3ad9cbaf0da6aa3" => :mavericks
    sha1 "8a249a030c0a5139d8eb0f5a488dac8faf7705c0" => :mountain_lion
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
