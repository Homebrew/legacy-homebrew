require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/8.1.1/BaseX811.zip'
  version '8.1.1'
  sha1 '14880d68460c6c67696dde86fba3a342d0920dde'

  bottle do
    cellar :any
    sha256 "680ac5ad68cb5867898c945734c9594805e7f2c13c99405d16993bc899826ad7" => :yosemite
    sha256 "9539d4f3dfb2e88bc895f751a955327e1c123470590c5b7e98b628d31db1b79c" => :mavericks
    sha256 "d24f992d3e7a3ca87d8f3d0be267b086347c41e8246f16bb12c04b4c71f1546c" => :mountain_lion
  end

  def install
    rm Dir['bin/*.bat']
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
