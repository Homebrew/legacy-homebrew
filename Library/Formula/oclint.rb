require 'formula'

class Oclint < Formula
  homepage 'http://oclint.org'
  url 'http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-apple-darwin-10.tar.gz'
  version '0.7'
  sha1 '867751f9e1b73515c22a014b22592b31c92f81bb'

  devel do
    url 'http://archives.oclint.org/nightly/oclint-0.8.dev.d78537d-x64_64-apple-darwin-12.tar.gz'
    version '0.8.dev.d78537d'
    sha1 '03ab470d0638087c42994ea12161178d1f9db47f'
  end

  def install
    lib.install Dir['lib/clang']
    lib.install Dir['lib/oclint']
    bin.install Dir['bin/*']
  end

  def test
    system "echo \"int main() { return 0; }\" > #{prefix}/test.m"
    system "#{bin}/oclint #{prefix}/test.m -- -c"
  end
end
