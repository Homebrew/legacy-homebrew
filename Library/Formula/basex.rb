require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/8.0.1/BaseX801.zip'
  version '8.0.1'
  sha1 '09bfa7243ea6f7e5225746d1359cee2cafab240d'

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
