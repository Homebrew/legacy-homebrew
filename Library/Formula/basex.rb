require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/7.5/BaseX75.zip'
  version '7.5'
  sha1 'da4ee9be44f34c9aa770e72a263d1a0ccf390f11'

  def install
    rm Dir['bin/*.bat']
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def test
    system "#{bin}/basex", "'1 to 10'"
  end
end
