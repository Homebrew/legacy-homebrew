require 'formula'

class Shellcheck < Formula
  homepage 'https://github.com/koalaman/shellcheck'
  url 'https://github.com/koalaman/shellcheck/archive/v0.2.0.zip'
  sha1 '5c66dbcad61aebe3f40a4735cfc6c02f322aa249'

  depends_on 'haskell-platform'

  def install
    system "cabal install"
  end

  test do
    system "which", "shellcheck"
  end
end
