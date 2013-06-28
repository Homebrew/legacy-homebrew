require 'formula'

class Oclint < Formula
  homepage 'http://oclint.org'
  url 'http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-apple-darwin12.tar.gz'
  version '0.7'
  sha1 'a8cc6b53fb1b843b16c8e5dd66086d8a950b990d'

  devel do
    url 'http://archives.oclint.org/nightly/oclint-0.8.dev.d78537d-x64_64-apple-darwin-12.tar.gz'
    version '0.8.dev.d78537d'
    sha1 '03ab470d0638087c42994ea12161178d1f9db47f'
  end

  def install
    clang_version = build.devel? ? 3.4 : 3.3

    lib.install Dir['lib/clang'] unless File.directory? "#{lib}/clang"
    "#{lib}/clang".install Dir['lib/clang/#{clang_version}'] unless File.directory? "#{lib}/clang/#{clang_version}"
    lib.install Dir['lib/oclint']
    bin.install Dir['bin/*']
  end

  def test
    system "#{bin}/oclint", "-version"
  end
end
