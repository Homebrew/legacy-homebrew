require 'formula'

class Narwhal < Formula
  homepage 'https://github.com/280north/narwhal'
  url 'https://github.com/280north/narwhal/tarball/v0.3.2'
  sha1 '64865fd335ad5078a32eee4504a98fdd6796199c'

  head 'https://github.com/280north/narwhal.git'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
