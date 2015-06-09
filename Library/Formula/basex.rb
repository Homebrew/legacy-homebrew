require 'formula'

class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/8.2.1/BaseX821.zip'
  version '8.2.1'
  sha256 '4073aa250a9551619b9fb254d3022da97b97d2b5085fdf7535fb92a53d3f1589'

  bottle do
    cellar :any
    sha256 "3a5da356958771ed48f4f7a2586c65466527c4d6922bffa3247a947a0c546517" => :yosemite
    sha256 "0c46862974b6510bb93ae33adc43567952f82650be0e646893a7d2c958b6c32e" => :mavericks
    sha256 "e5b1a5088b3237266d5676a504f44eff782bb5bf08bc4485473ec6be27866dc6" => :mountain_lion
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
