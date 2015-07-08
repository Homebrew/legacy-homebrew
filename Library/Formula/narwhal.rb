require 'formula'

class Narwhal < Formula
  desc "General purpose JavaScript platform for building applications"
  homepage 'https://github.com/280north/narwhal'
  head 'https://github.com/280north/narwhal.git'
  url 'https://github.com/280north/narwhal/archive/v0.3.2.tar.gz'
  sha1 'c93c6ad673e9e58642c1a46f493e16fc808bce60'

  conflicts_with 'spidermonkey', :because => 'both install a js binary'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
