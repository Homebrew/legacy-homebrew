require 'formula'

class Tegh < Formula
  homepage 'https://github.com/D1plo1d/tegh'
  url 'https://github.com/D1plo1d/tegh.git', :tag => '0.2.0'
  head 'https://github.com/D1plo1d/tegh.git', :branch => 'develop'

  depends_on 'node'

  def install
    system "npm", "install"
    prefix.install 'package.json'
    prefix.install Dir['src']
    prefix.install Dir['node_modules']
    bin.install Dir['bin/tegh']
  end

  test do
    system "tegh"
  end
end
