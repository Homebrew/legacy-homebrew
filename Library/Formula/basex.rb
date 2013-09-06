require 'formula'

class Basex < Formula
  homepage 'http://basex.org'
  url 'http://files.basex.org/releases/7.7/BaseX77.zip'
  version '7.7'
  sha1 '49bb088b6eba892d55733685c78c46e9d313bf7c'

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
