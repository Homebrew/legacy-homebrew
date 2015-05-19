require 'formula'

class Tegh < Formula
  desc "Command-line client for Prontserve"
  homepage 'https://github.com/D1plo1d/tegh'
  head 'https://github.com/D1plo1d/tegh.git', :branch => 'develop'
  url 'https://s3.amazonaws.com/tegh_binaries/0.3.1/tegh-0.3.1-brew.tar.gz'
  sha1 '7061165db148a27d229563e340d6c691b4fd92a8'

  depends_on 'node'

  def install
    rm "bin/tegh.bat"
    system "npm", "install" if build.head?
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
