require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/7.7.2/BaseX772.zip'
  version '7.7.2'
  sha1 '95dbb4f500df54ff38a3457c47d8fe512233dd56'

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
    require 'open3'
    Open3.popen3("#{bin}/basex", "1 to 10") do |_, stdout, _|
      assert_equal "1 2 3 4 5 6 7 8 9 10", stdout.read
    end
  end
end
