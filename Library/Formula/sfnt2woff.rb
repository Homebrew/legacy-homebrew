require 'formula'

class Sfnt2woff < Formula
  homepage 'http://people.mozilla.com/~jkew/woff/'
  url 'http://people.mozilla.com/~jkew/woff/woff-code-latest.zip'
  sha1 '59879f1bdeeafce7fc9d4b51406e80d7a4cd0293'

  def install
    system 'make all'
    bin.install 'sfnt2woff'
  end

  def test
    system 'sfnt2woff'
  end
end