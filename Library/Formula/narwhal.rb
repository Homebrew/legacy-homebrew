require 'formula'

class Narwhal < Formula
  homepage 'https://github.com/280north/narwhal'
  url 'https://github.com/280north/narwhal/archive/v0.3.2.tar.gz'
  sha1 'c93c6ad673e9e58642c1a46f493e16fc808bce60'

  head 'https://github.com/280north/narwhal.git'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
