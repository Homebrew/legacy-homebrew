require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/7.9/BaseX79.zip'
  version '7.9'
  sha1 'd5630ab597dfade196646d3ad38ea6b39593efe2'

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
    assert_equal "1 2 3 4 5 6 7 8 9 10", shell_output("#{bin}/basex '1 to 10'")
  end
end
