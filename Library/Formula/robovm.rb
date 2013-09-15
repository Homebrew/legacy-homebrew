require 'formula'

class Robovm < Formula
  homepage 'http://www.robovm.org'
  url 'http://download.robovm.org/robovm-0.0.4.tar.gz'
  version '0.0.4'
  sha1 'cd64444948b8ec48dccce6e1077be5c25c34ba04'

  def install
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
    lib.install_symlink Dir["#{libexec}/lib/*"]
  end

  def test
    system "robovm -version"
  end
end
