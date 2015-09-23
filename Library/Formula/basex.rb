class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "http://basex.org"
  url "http://files.basex.org/releases/8.3/BaseX83.zip"
  version "8.3"
  sha256 "0523f6904831687479b63642217933d971b8a9faf7e48ca6ed49fb89e7136a99"

  bottle do
    cellar :any_skip_relocation
    sha256 "589af13889dfaf5b5bd24c2008e0d6519024a9b9554b97271b2becde82266e94" => :el_capitan
    sha256 "53bfb47999e96d7b0588508842c04554458a021fcf54d6f4c06c21d974293aa5" => :yosemite
    sha256 "b5d6cc9b0ef86193a04759c832478d26267b39338896a92446d258bf7d99f473" => :mavericks
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
