require 'formula'

class Jeo < Formula
  homepage 'http://jeo.github.io'
  url 'http://ares.boundlessgeo.com/jeo/release/0.1/jeo-0.1-cli.zip'
  sha1 '048b0fde2cc1577853b584e05360878e1944178a'

  def install
    rm Dir['bin/*.{bat,cmd,dll,exe}']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/jeo", "-v"
  end
end
