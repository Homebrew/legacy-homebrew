require 'formula'

class Hatop < Formula
  homepage 'http://feurix.org/projects/hatop/'
  url 'http://hatop.googlecode.com/files/hatop-0.7.7.tar.gz'
  sha1 '1d4f46cc8613746e9310debf0a8632f366619710'

  def install
    bin.install 'bin/hatop'
    man1.install 'man/hatop.1'
  end

  def test
    system "which", "hatop"
  end
end
