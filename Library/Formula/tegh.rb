require 'formula'

class Tegh < Formula
  url 'https://github.com/D1plo1d/tegh.git', :tag => '0.2.0'
  version '0.2.0'
  homepage 'https://github.com/D1plo1d/tegh'
  head 'https://github.com/D1plo1d/tegh.git', :branch => 'develop'

  depends_on 'node'

  def install
    system "npm", "install"
    prefix.install Dir['*']
  end

  test do
    system "tegh"
  end
end
