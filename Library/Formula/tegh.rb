require 'formula'

class Tegh < Formula
  homepage 'https://github.com/D1plo1d/tegh'
  head 'https://github.com/D1plo1d/tegh.git'

  depends_on 'node'
  depends_on 'coffee-script'

  def install
    system "npm", "install"
    prefix.install Dir['*']
  end

  test do
    system "tegh"
  end
end
