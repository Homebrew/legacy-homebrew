class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/8.2.3/BaseX823.zip"
  version "8.2.3"
  sha256 "69167fc8bbac97fd140404c1c37572016b23488bec7fc85fa19fdb391f33f3b8"

  bottle do
    cellar :any
    sha256 "3a60d9d8bfb00f2defe4cdedaa802594d1ec7d64ccc47d50b0a4c7c87e4a3a7c" => :yosemite
    sha256 "b0148c05d4b7158a74e487d9768b3c40b1482fd316cc638dc8494cb4e98c1a3d" => :mavericks
    sha256 "ebaa68271b2801062ca47d876a6ef3c81990cdb9cb7289f68d4245c0e752d4b1" => :mountain_lion
  end

  def install
    rm Dir["bin/*.bat"]
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
