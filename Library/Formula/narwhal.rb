require 'formula'

class Narwhal < Formula
  homepage 'https://github.com/280north/narwhal'
  url 'https://github.com/280north/narwhal/tarball/v0.3.2'
  md5 'c5f8c0af38b79a7a7b827d3f05f79e21'

  head 'https://github.com/280north/narwhal.git'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
