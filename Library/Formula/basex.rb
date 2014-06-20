require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/7.8.2/BaseX782.zip'
  version '7.8.2'
  sha1 '0fe690eb10cb5bc79491e3ece3cbce365840524e'

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
