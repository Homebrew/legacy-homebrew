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
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test robovm`.
    system "robovm -version"
  end
end
