require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/7.6/BaseX76.zip'
  version '7.6'
  sha1 '7c90082770530d4b0c9f4327da558de0fc28ee9c'

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
